require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'debugger'

# The example provided to us:
# File.open('books.txt', 'w') do |f|
# page = Nokogiri::HTML(open("http://www.books.com"))
# books = page.css('table tr td:first-child span')
# books.each do |book|
# f.write(“<div>” + book + "</div>\n")
# end
#   end
# end

class Country
  attr_accessor :name, :exports
  def initialize(name, exports)
    @name = name
    @exports = exports
  end


end


File.open('data.html', 'w') do |f|
  page = Nokogiri::HTML(open("http://data.worldbank.org/indicator/TX.VAL.TECH.CD"))
  rows = page.css('tbody tr')

  dated_info = Nokogiri::HTML(open("http://data.worldbank.org/indicator/TX.VAL.TECH.CD?page=4"))
  old_rows = dated_info.css('tbody tr')
  
  f.write("<!DOCTYPE HTML>")
  f.write("<html>")
    f.write("<head>")
    f.write("<title>Top exporters of high technology goods</title>")
    f.write('<link type="text/css" rel="stylesheet" href="data.css"/>')
  f.write("</head>")
  f.write("<body>")
    f.write("<div class='header_bar'></div>")
    f.write("<div class='container'>")
      f.write("<div class='heading'> <h1>Tech for Sale</h1></div>")

      f.write("<div class='left_side'><p>Two decades wrought huge changes in international markets for high tech goods. 
        The volume of trade showed steady increases around the globe with China vaulting to the lead, even though
        it had been completely absent from the list in 1991. The Asian Tigers demonstrated their staying power, outpacing
        Europe.</p><p>To be honest, I was really just interested in today's top 10 exporters of thinking that might provide some insight about 
        the state of high technology goods in the world that I might not have known about. Then I got the data scraped and realized it would 
        be easy to pull in another table for context.</p><p>And it's not like my analysis of a single indicator is going to be that informative, 
        so now I'm just providing some more text to fill out my page. I could talk about the vicissitudes of international trade or something 
        those lines, but my ramblings at least have an honesty that has to be better than platitudes about globalization.</p>

        <p>Then I went back and looked at the example provided for us and discovered that maybe I should make a graph instead. 
        So let's see how that goes.</div>")
      f.write("<div>")
      f.write("<table>")
        f.write("<thead>")
          f.write("<tr><th class='table_heading'>2011</th></tr>")
          f.write("<tr><th>Country</th><th>Exports (in USD)</th></thead>")
        f.write("</thead>")
        
        f.write("<tbody>")

          array_of_countries = []
          counter = 0

          # until counter == rows.length - 9 # -9 because there are elements below that in the table that are not countries
          #   array_of_countries << ('<tr><td>' + rows[counter].css('a').text + '</td>
          #     <td>' + rows[counter].css('td')[4].text.gsub("\n", "").squeeze + '</td></tr>')
          #   counter += 1
          # end


          until counter == rows.length - 9
            @country = Country.new(rows[counter].css('a').text, rows[counter].css('td')[4].text.gsub("\n", "").gsub(",", "").strip)
            array_of_countries << @country
            counter += 1

          end


          array_of_countries.select!{|x| x.exports.to_i > 1 }
          array_of_countries.sort!{|x, y| y.exports.to_i <=> x.exports.to_i}
          array_of_countries[0..9].each{|x| f.write "<tr><td class='country_name'>#{x.name}</td><td>#{x.exports}</td></tr>\n"}
        f.write("</tbody>")
      f.write("</table>")
      
      f.write("<table class='bottom_table'>")
        f.write("<thead>")
          f.write("<tr><th class='table_heading'>1991</th></tr>")
          f.write("<tr><th>Country</th><th>Exports (in USD)</th></tr>")
        f.write("</thead>")
        
        f.write("<tbody>")
        old_array = []
        counter = 0
        until counter == old_rows.length - 9
          @old_country = Country.new(old_rows[counter].css('a').text, old_rows[counter].css('td')[4].text.gsub("/n", "").gsub(",", "").strip.to_i)
          old_array << @old_country
          counter += 1
        end

        old_array.select!{|x| x.exports > 1}
        old_array.sort!{|x, y| y.exports <=> x.exports}
          old_array[0..9].each{|x| f.write "<tr><td class='country_name'>#{x.name}</td><td>#{x.exports}</td></tr>\n"}
        f.write("</tbody>")
      f.write("</table>")
      f.write("</div>")

      f.write("<div class='graph_container'>")
         
         f.write("<div class='old_graph'><h5>1991</h5><h6>(in billions of US dollars)</h6>")
          old_array[0..9].reverse.each{|x| f.write("<div class='barchart' style='height:#{(x.exports.to_i/1000000000)}px'> #{x.name[0]}</div>")}
        f.write("</div>")

        f.write("<div class='new_graph'><h5>2011</h5><h6>(in billions of US dollars)</h6>")
          array_of_countries[0..9].reverse.each{|x| f.write("<div class='barchart' style='height:#{(x.exports.to_i/1000000000)}px'> #{x.name[0]}</div>")}
        f.write("</div>")
        

        f.write("</div>")
       f.write("</div>")
      f.write("</div>")
    f.write("</div>")
    f.write("<div class='footer_bar'></div>")
  f.write("</body>")
  f.write("</html>")
end



