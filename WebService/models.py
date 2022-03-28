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


# MARK: - OLD Models for the API
class Tool(BaseModel):
    """
    Tool model
    """
    toolName: str
    toolURL: Optional[str]

class CompanyImplant(BaseModel):
    implantName: str
    implantURL: Optional[str]
    techniqueGuide: Optional[str]
    tools: Optional[List[Tool]]

class ImplantImage(BaseModel):
    """
    Implant Image model
    """
    implantName: str
    imageURL: str


# MARK: - New Models
class Guide(BaseModel):
    type: str
    URL: str

class Implant(BaseModel):
    """
    Implant model
    """
    implantName: str
    implantURL: Optional[str]
    guides: Optional[List[Guide]]
    
class Company(BaseModel):
    """
    Company Model
    """
    companywide_guides: Optional[List[Guide]]
    implants: List[Implant]
