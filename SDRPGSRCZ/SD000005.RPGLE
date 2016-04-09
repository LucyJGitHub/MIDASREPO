     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Initialisation program for CSW203')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000005 - Initialisation Program for CSW203                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSW203  *CREATE    Date 26May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW203 - SWIFT 2003 Standards Update                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR       - Initialise                                    *
      *  *PSSR        - Error processing                              *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD SWIFT codewords data
     FSDCODEPD  UF   E             DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
      ** SAR Descriptions
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** Data Structures used by Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters used by access object
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
 
      ** Variables used as enhancements indicators
     D CFT013          S              1
     D CFT014          S              1
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Read the first record from Midas SD SWIFT codewords data
 
     C                   READ      SDCODEPD
 
      ** Do while end of file not reached.
 
     C                   DOW       NOT %EOF(SDCODEPD)
 
      ** If CFT013 is installed, update the record where Message Type = '100',
      ** and Midas Module ID = 'DL', LE' or 'SE' to have Message Type = '103'
 
     C                   IF        CFT013 = 'Y' AND FYSMTP = '100'
 
     C                   IF        FYMMID = 'DL' OR
     C                             FYMMID = 'LE' OR
     C                             FYMMID = 'SE' OR
     C                             FYMMID = 'FI'
     C                   EVAL      FYSMTP = '103'
     C                   UPDATE    SDCODED0
     C                   ENDIF
 
     C                   ENDIF
 
      ** If CFT014 is installed, update the record where Message
      ** Type = '100' and Midas Module ID = 'FT' to have Message Type = '103'
 
     C                   IF        CFT014 = 'Y'
 
     C                   IF        FYMMID = 'FT' AND FYSMTP = '100'
     C                   EVAL      FYSMTP = '103'
     C                   UPDATE    SDCODED0
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record.
 
     C                   READ      SDCODEPD
 
     C                   ENDDO
 
     C                   MOVE      *ON           *INLR
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  'SD000005'
     C                   OUT       LDA
 
      ** Initialize enhancements indicator
 
     C                   EVAL      CFT013 = 'N'
     C                   EVAL      CFT014 = 'N'
 
      ** Access AOSARDR0 to check if CFT013 is switched on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFT013'      PSARD
     C     SCSARD        PARM      *BLANKS       DSFDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CFT013 = 'Y'
     C                   ENDIF
 
      ** Access AOSARDR0 to check if CFT014 is switched on
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFT014'      PSARD
     C     SCSARD        PARM      *BLANKS       DSFDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CFT014 = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBFILE = 'SDCODEPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
 
     C                   DUMP
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
