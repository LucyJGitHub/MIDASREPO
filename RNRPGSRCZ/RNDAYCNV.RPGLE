     h nomain
 
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FRS Return iso date from midas day no.')
      *****************************************************************
      *                                                               *
      *  Midas - FRS Regulatory Reporting                             *
      *                                                               *
      *  RNDAYCNV   - Convert Midas Day Number to Date                *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CRN001  *CREATE    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CRN001 - FRS Regulatory Reporting                            *
      *                                                               *
      *****************************************************************
 
      /copy rncpysrc,rndaycnv
 
      *=====================================================================
 
     p rnDayCnv        b                   export
 
     d                 pi                  like(rnDayCnv)
     d midasDayNo                     5  0 const
 
     d midasDay0       c                   d'1971-12-31'
 
     c                   if        midasDayNo  > 0
     c                   return    %char(midasDay0 + %days(midasDayNo))
     c                   else
     c                   return    *blanks
     c                   endif
 
     p                 e
