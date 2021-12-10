from pydantic import BaseModel
from typing import List, Optional
import datetime
import uuid



# This is the individual result
class ResultsItem(BaseModel):
    company: str
    percentage: float



class Classification(BaseModel):
    """
    Classifications model
    """
    id: str
    date: datetime.date
    predictedCompany: str
    predictionConfidence: float
    classifications: List[ResultsItem]


def simulateResults():
    from random import random, shuffle
    companies = list(["Acumed", "Synthes", "Trimed"])
    print(companies)
    shuffle(companies)
    sum = 100

    results = []
    for company in companies:
        percentage = random() * sum
        results.append(ResultsItem(company=company, percentage=percentage))
        sum -= percentage
    print(results)

    results.sort(key=lambda x: x.percentage, reverse=True)

    return Classification(
        id=str(uuid.uuid4()),
        date=datetime.date.today(),
        predictedCompany=results[0].company,
        predictionConfidence=results[0].percentage,
        classifications=results
    )




