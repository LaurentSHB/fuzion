# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Fuzion::Application.initialize!


SYSTEM_MAILER = "Parlez Moi d'Immo 2 <no-reply@footfuzion.fr>"

YEARS = [["Saison 2011-2012", 2012], ["Saison 2011-2012", 2011], ["Saison 2010-2011", 2010], ["Saison 2009-2010", 2009], ["Saison 2008-2009", 2008]]
CURRENT_YEAR = 2012