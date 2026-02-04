class Nft < ApplicationRecord
  STATUSES = %w[pending minting minted failed].freeze
  NETWORKS = %w[polygon polygon_mumbai].freeze

  # Polygon Contract Address (deployed contract)
  POLYGON_CONTRACT = ENV.fetch("NFT_CONTRACT_ADDRESS", "0x0000000000000000000000000000000000000000")

  belongs_to :post
  belongs_to :user

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :network, presence: true, inclusion: { in: NETWORKS }
  validates :post_id, uniqueness: { scope: :user_id, message: "already has an NFT for this user" }

  scope :pending, -> { where(status: 'pending') }
  scope :minted, -> { where(status: 'minted') }
  scope :failed, -> { where(status: 'failed') }
  scope :by_recent, -> { order(created_at: :desc) }

  def pending?
    status == 'pending'
  end

  def minted?
    status == 'minted'
  end

  def failed?
    status == 'failed'
  end

  def opensea_url
    return nil unless minted? && token_id.present?
    
    case network
    when 'polygon'
      "https://opensea.io/assets/matic/#{contract_address}/#{token_id}"
    when 'polygon_mumbai'
      "https://testnets.opensea.io/assets/mumbai/#{contract_address}/#{token_id}"
    end
  end

  def polygonscan_url
    return nil unless transaction_hash.present?
    
    case network
    when 'polygon'
      "https://polygonscan.com/tx/#{transaction_hash}"
    when 'polygon_mumbai'
      "https://mumbai.polygonscan.com/tx/#{transaction_hash}"
    end
  end

  def self.eligible_for_minting?(post)
    # Post must have a minimum score to be eligible for NFT
    post.score >= 10
  end

  def mint!
    return false unless pending?
    
    update!(status: 'minting')
    
    # TODO: Integrate with actual Polygon minting service
    # This would typically:
    # 1. Upload metadata to IPFS
    # 2. Call smart contract to mint
    # 3. Wait for transaction confirmation
    # 4. Update token_id and transaction_hash
    
    # Simulate minting for demo
    simulate_minting
  end

  private

  def simulate_minting
    # Simulate async minting (in real implementation, this would be a background job)
    self.token_id = SecureRandom.hex(32)
    self.contract_address = POLYGON_CONTRACT
    self.transaction_hash = "0x#{SecureRandom.hex(32)}"
    self.metadata_url = "ipfs://#{SecureRandom.hex(32)}"
    self.minted_at = Time.current
    self.status = 'minted'
    save!
  end
end
