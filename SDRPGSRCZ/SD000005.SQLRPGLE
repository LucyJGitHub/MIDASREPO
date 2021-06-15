     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/**** *  RPGBASEMOD                                                   *                     MD056888
/*STD *  RPGSQLMOD                                                    *                     MD056888
/*EXI *  CLOSQLCSR(*ENDMOD)                                           *                     MD056888
/*EXI *  TEXT('Midas SD Initialisation program for CSW203')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000005 - Initialisation Program for CSW203                 *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD056888           Date 20Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW203  *CREATE    Date 26May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056888 - Deliverable Data Split for SDCODEPD               *
      *  MD046248 - Finastra Rebranding                               *
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
     F*SDCODEPD* UF   E             DISK    INFSR(*PSSR)                                    MD056888

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

     D SDCODE        E DS                  EXTNAME(SDCODJW0)                                MD056888
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

     C**********         READ      SDCODEPD                                                 MD056888
                                                                                            MD056888

      ** Do while end of file not reached.

     C**********         DOW       NOT %EOF(SDCODEPD)                                       MD056888

      ** If CFT013 is installed, update the record where Message Type = '100',
      ** and Midas Module ID = 'DL', LE' or 'SE' to have Message Type = '103'

     C**********         IF        CFT013 = 'Y' AND FYSMTP = '100'                          MD056888
     C                   IF        CFT013 = 'Y'                                             MD056888
      **********                                                                            MD056888
     C**********         IF        FYMMID = 'DL' OR                                         MD056888
     C**********                   FYMMID = 'LE' OR                                         MD056888
     C**********                   FYMMID = 'SE' OR                                         MD056888
     C**********                   FYMMID = 'FI'                                            MD056888
     C**********         EVAL      FYSMTP = '103'                                           MD056888
     C**********         UPDATE    SDCODED0                                                 MD056888
     C/EXEC SQL                                                                             MD056888
     C+ update SDCODXTD                                                                     MD056888
     C+ set FYSMTP = '103'                                                                  MD056888
     C+ where (FYMMID = 'DL' or FYMMID = 'LE' or                                            MD056888
     C+        FYMMID = 'SE' or FYMMID = 'FI') and FYSMTP = '100'                           MD056888
     C/END-EXEC                                                                             MD056888
     C**********         ENDIF                                                              MD056888

     C                   ENDIF

      ** If CFT014 is installed, update the record where Message
      ** Type = '100' and Midas Module ID = 'FT' to have Message Type = '103'

     C                   IF        CFT014 = 'Y'

     C**********         IF        FYMMID = 'FT' AND FYSMTP = '100'                         MD056888
     C**********         EVAL      FYSMTP = '103'                                           MD056888
     C**********         UPDATE    SDCODED0                                                 MD056888
     C/EXEC SQL                                                                             MD056888
     C+ update SDCODXTD                                                                     MD056888
     C+ set FYSMTP = '103'                                                                  MD056888
     C+ where (FYMMID = 'FT' and FYSMTP = '100')                                            MD056888
     C/END-EXEC                                                                             MD056888
     C**********         ENDIF                                                              MD056888

     C                   ENDIF

      ** Read next record.

     C**********         READ      SDCODEPD                                                 MD056888
      **********                                                                            MD056888
     C**********         ENDDO                                                              MD056888

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
