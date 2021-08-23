     H DEBUG
     F*****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('Midas Italy Set-up Utility for A/C Code Ext File ')    *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Standing data Module                                 *
      *                                                               *
      ***RPG/UTIL06*-*Account*code*Ext.*File*Set-up*Utility************                       LUC109
      *  RPG/XXUT0006 - Account code Ext. File Set-up Utility         *                       LUC109
  ?   *****************************************************************
  ?   ******THIS*PROGRAM*MUST*BE*COMPILED*WITH*XXINTFLIB*AT*THE*TOP****                       LUC109
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT BOTTOM    *                       LUC109
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function:  This program populates the Account Codes          *
      *             Extension file with a default value of 'N'.       *
      *                                                               *
      ***Called*By:*GLCM035.*******************************************                       LUC109
      *  Called By: XXC000035                                         *                       LUC109
      *                                                               *
      **(c)*Copyright*Midas-Kapiti*International*Ltd.*1999*************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 22Sep16               *
      *  Prev amend No. MMI043             Date 07Jul99               *
      *                 MMI043 *Create     Date 19May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MMI043 - Program renamed from MMI043UT1 to UTIL06.           *
      *           Calling program changed to GLCM035 every COB        *
      *           instead of once from the command line.              *
      *  MMI043 - Change Control 7: Extract OOB                       *
      *                                                               *
      *****************************************************************
     FSDACODL1  IF   E           K DISK
     FSDACODX1  O    E             DISK
      *-------------------------------------------------------------------------
      *                                                                              MMI031
      *-------------------------------------------------------------------------
     D A@CPY           DS
      * MKI Copyright array
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)              COPYRIGHT  ARRAY
      /EJECT
      *-------------------------------------------------------------------------
      *
     C                   READ      SDACODL1                               30
     C     *IN30         DOWEQ     *OFF
     C                   MOVE      A5ACCD        MACCD
     C                   MOVE      'N'           MEXTF
     C                   WRITE     SDACODD1
     C                   READ      SDACODL1                               30
     C                   ENDDO
     C                   MOVE      *ON           *INLR
     C                   RETURN
      /EJECT
      *****************************************************************             MMI031
      *                                                                             MMI031
**CTDATA CPY@
(c) Finastra International Limited 2016
