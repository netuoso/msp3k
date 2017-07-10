class MspDelegator < ApplicationRecord
  has_paper_trail only: [:delegated_mvests, :blacklisted]

  def self.fetch
    SteemApi::Connection.connection.exec_query(self.canned_query(SteemApi::Connection.steem_per_mvests))
  end

  private

  def self.canned_query(steem_per_vest)
    "SELECT delegatee AS Recipient, delegator AS Delegator, CONVERT(DECIMAL(15,2),vesting_shares / 1000000) AS MVests, CONVERT(DECIMAL(15,0),ROUND(vesting_shares * #{SteemApi::Connection.steem_per_mvests}/1000000, 0)) AS SP, timestamp as 'Latest Time Stamp' FROM
    (SELECT delegator,
            delegatee,
            vesting_shares,
            timestamp,
            row_number() over (partition by delegator, delegatee ORDER BY timestamp DESC ) as rn
        FROM TxDelegateVestingShares
        WHERE delegatee IN ('minnowsupport','msp-lovebot','msp-creativebot','centerlink','msp-africa','msp-shanebot')
        AND timestamp IS Not Null
    ) tt
    WHERE tt.rn = 1 AND vesting_shares <> 0
    ORDER BY delegatee, SP DESC"
  end

end
