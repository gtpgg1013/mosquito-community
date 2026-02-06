# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Seeding Avatar Items..."

# Head Items - 모기 헌터 테마 모자/머리 장식
head_items = [
  { name: "기본 모자", emoji: "🧢", category: "head", rarity: "common", description: "평범한 모자", price: 0 },
  { name: "모기 뿔 머리띠", emoji: "👹", category: "head", rarity: "common", description: "귀여운 모기 뿔이 달린 머리띠", price: 100 },
  { name: "헌터 헬멧", emoji: "⛑️", category: "head", rarity: "rare", description: "전문 모기 헌터의 헬멧", price: 500 },
  { name: "모기장 모자", emoji: "🎭", category: "head", rarity: "rare", description: "실용적인 모기장이 달린 모자", price: 600 },
  { name: "전기 파리채 왕관", emoji: "⚡", category: "head", rarity: "epic", description: "전기 파리채로 만든 왕관", price: 1500 },
  { name: "황금 모기 왕관", emoji: "👑", category: "head", rarity: "legendary", description: "전설의 모기 헌터에게만 주어지는 왕관", price: 5000 },
]

# Body Items - 의상
body_items = [
  { name: "기본 티셔츠", emoji: "👕", category: "body", rarity: "common", description: "평범한 티셔츠", price: 0 },
  { name: "모기 퇴치 조끼", emoji: "🦺", category: "body", rarity: "common", description: "레몬그라스 향이 나는 조끼", price: 100 },
  { name: "위장 유니폼", emoji: "🥋", category: "body", rarity: "rare", description: "밤에 모기를 잡기 위한 위장복", price: 500 },
  { name: "방호복", emoji: "🛡️", category: "body", rarity: "rare", description: "모기에게 물리지 않는 특수 방호복", price: 700 },
  { name: "네온 아머", emoji: "💎", category: "body", rarity: "epic", description: "빛나는 네온 컬러 갑옷", price: 1800 },
  { name: "레전더리 헌터 슈트", emoji: "🦸", category: "body", rarity: "legendary", description: "1000마리 이상 잡은 헌터의 슈트", price: 6000 },
]

# Background Items - 배경
background_items = [
  { name: "기본 배경", emoji: "🌫️", category: "background", rarity: "common", description: "심플한 그라데이션 배경", price: 0 },
  { name: "여름 밤", emoji: "🌙", category: "background", rarity: "common", description: "모기가 가장 많은 여름 밤", price: 100 },
  { name: "습지대", emoji: "🏞️", category: "background", rarity: "rare", description: "모기의 서식지 습지대", price: 400 },
  { name: "정글", emoji: "🌴", category: "background", rarity: "rare", description: "열대 정글 배경", price: 500 },
  { name: "네온 시티", emoji: "🌃", category: "background", rarity: "epic", description: "사이버펑크 도시 배경", price: 1500 },
  { name: "말라리아 퇴치 본부", emoji: "🏥", category: "background", rarity: "epic", description: "WHO 말라리아 퇴치 본부", price: 2000 },
  { name: "우주 정거장", emoji: "🚀", category: "background", rarity: "legendary", description: "우주에서도 모기를 잡는 헌터", price: 5500 },
]

# Accessory Items - 무기/액세서리
accessory_items = [
  { name: "파리채", emoji: "🪤", category: "accessory", rarity: "common", description: "기본 파리채", price: 0 },
  { name: "모기향", emoji: "🌀", category: "accessory", rarity: "common", description: "전통적인 모기향", price: 50 },
  { name: "전기 파리채", emoji: "⚡", category: "accessory", rarity: "rare", description: "치직! 전기 파리채", price: 400 },
  { name: "모기 스프레이", emoji: "🧴", category: "accessory", rarity: "rare", description: "강력한 모기 퇴치 스프레이", price: 450 },
  { name: "레이저 포인터", emoji: "🔦", category: "accessory", rarity: "epic", description: "모기를 추적하는 레이저", price: 1200 },
  { name: "모기 탐지 드론", emoji: "🛸", category: "accessory", rarity: "epic", description: "AI로 모기를 탐지하는 드론", price: 2500 },
  { name: "플라즈마 블레이드", emoji: "🗡️", category: "accessory", rarity: "legendary", description: "모기를 원자 단위로 분해", price: 8000 },
]

all_items = head_items + body_items + background_items + accessory_items

all_items.each do |item_attrs|
  item = AvatarItem.find_or_initialize_by(name: item_attrs[:name])
  item.category = item_attrs[:category]
  item.rarity = item_attrs[:rarity]
  item.description = item_attrs[:description]
  item.price = item_attrs[:price]
  item.emoji = item_attrs[:emoji]
  item.save!
end

puts "Created #{AvatarItem.count} avatar items!"
puts "  - Head: #{AvatarItem.heads.count}"
puts "  - Body: #{AvatarItem.bodies.count}"
puts "  - Background: #{AvatarItem.backgrounds.count}"
puts "  - Accessory: #{AvatarItem.accessories.count}"

# Sample Donation Data
puts "\nSeeding Donations..."

donations = [
  { amount: 5000, organization: "Against Malaria Foundation", donated_at: 6.months.ago, notes: "2024년 상반기 기부금" },
  { amount: 3500, organization: "Malaria Consortium", donated_at: 5.months.ago, notes: "모기잡이 커뮤니티 첫 기부" },
  { amount: 4200, organization: "Against Malaria Foundation", donated_at: 4.months.ago, notes: "월간 정기 기부" },
  { amount: 2800, organization: "Nothing But Nets", donated_at: 3.months.ago, notes: "모기장 구매 지원" },
  { amount: 5500, organization: "Against Malaria Foundation", donated_at: 2.months.ago, notes: "특별 캠페인 기부" },
  { amount: 3200, organization: "WHO Malaria Program", donated_at: 1.month.ago, notes: "WHO 말라리아 프로그램 지원" },
  { amount: 4800, organization: "Against Malaria Foundation", donated_at: 2.weeks.ago, notes: "2024년 하반기 기부금" },
  { amount: 2500, organization: "Malaria Consortium", donated_at: 1.week.ago, notes: "월간 정기 기부" },
]

donations.each do |donation_attrs|
  Donation.find_or_create_by!(
    organization: donation_attrs[:organization],
    donated_at: donation_attrs[:donated_at]
  ) do |donation|
    donation.amount = donation_attrs[:amount]
    donation.notes = donation_attrs[:notes]
  end
end

puts "Created #{Donation.count} donations!"
puts "  Total donated: $#{Donation.total_donated.to_i}"
