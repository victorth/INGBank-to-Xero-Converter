require 'csv'

puts "Which csv file would you like to XeroProof?"
file = gets.chomp

file_name = File.basename(file, ".*")

transactions_csv = CSV.read(file, headers:true)

# Remove some unwanted columns
transactions_csv.delete('Rekening')
transactions_csv.delete('Tegenrekening')
transactions_csv.delete('Code')
transactions_csv.delete('MutatieSoort')

CSV.open(file_name + "_XeroProof.csv", 'wb') do |csv|
	csv << ['Date', 'Payee', 'Transaction Type', 'Transaction Amount', 'Description', 'Reference'] # Add new headers
	transactions_csv.each do |row|
		# Replace comma for dots
		amount = row['Bedrag (EUR)']
		amount.sub!(',', '.')

		if (row['Af Bij'] == 'Af')
			row['Bedrag (EUR)'] = amount.to_f * -1
		end

		#row['Reference'] = row['Mededelingen'].split(/\bOmschrijving: \b/).last

		csv << row
	end
end

puts "All set! #{file_name}_XeroProof.csv has been created."