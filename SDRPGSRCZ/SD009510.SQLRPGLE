     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/**** *  RPGBASEBND                                                   *                     MD054605
/*STD *  RPGSQLBND                                                    *                     MD054605
/*EXI *  TEXT('Midas SD Change system value setting')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD009510 - Change System Value Setting                       *
      *                                                               *
      *  Function:  This program updates the system value file        *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD054605           Date 17Oct19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 23Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 05Jan06               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 CSD013  *CREATE    Date 23Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054605 - Deliverable Data Split                            *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *           (Recompile)                                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSD013 - Generic ICD project:                                *
      *           - New program.                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** � F-specs                              �
      ** � =======                              �
      ** +--------------------------------------+

     F*SDSVALL0* UF   E           K DISK                                                    MD054605

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** � D-specs                              �
      ** � =======                              �
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
      ** +--------------------------------------+
      ** � Named constants                      �
      ** � ===============                      �
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** � Arrays and Data Structures           �
      ** � ==========================           �
      ** +--------------------------------------+


      ** +--------------------------------------+
      ** � Declared variables                   �
      ** � ==================                   �
      ** +--------------------------------------+

     D @RUN            S              1
     D SysValKey       S             20
     D NewSysVal       S            200
     D SuppUpd         S             20
     D SDSVAL        E DS                  EXTNAME(SDSVLJW0)                                MD054605
     D NullInds        s              5i 0 dim(21)                                          MD054605

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** �                                                                �
      ** � Initial processing is performed automatically: the *INZSR is   �
      ** � executed at program activation.                                �
      ** �                                                                �
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Read in Installation Data
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
      *
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   END

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *entry        PLIST
     C                   PARM                    SysValKey
     C                   PARM                    NewSysVal
     C                   PARM                    SuppUpd
      *
      ** Read the required record from the System Values file
      *
     C*****SysValKey     CHAIN     SDSVALL0                           9999                  MD054605
     C/EXEC SQL                                                                             MD054605
     C+ SELECT *                                                                            MD054605
     C+ into :SDSVAL :NullInds                                                              MD054605
     C+ from SDSVLJW0                                                                       MD054605
     C+ where GISVAL = :SysValKey                                                           MD054605
     C/END-EXEC                                                                             MD054605
     C                   If        SQLCODE <> 0                                             MD054605
     C                   SETON                                        99                    MD054605
     C                   Else                                                               MD054605
     C                   SETOFF                                       99                    MD054605
     C                   ENDIF                                                              MD054605
                                                                                            MD054605
      *
      ** Record not found - Error
      *
     C                   IF        *IN99  = *ON
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'SDSVALL0'
     C                   EVAL      DBKEY  =  SysValKey
     C                   EVAL      DBPGM  =  'SD009510'
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  'SD009510'
     C                   EVAL      DBPROC =  '*INZ'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Record found
      *
      ** Update the system value field with the new value
      *
     C                   EVAL      GIVAL = NewSysVal
      *
      ** If the update restrictions field has had a new value delivered
      ** Update the suppress field with the new value
      *
     C     SuppUpd       IFNE      *Blanks
     C     SuppUpd       IFEQ      'BLANKOUT'                                                 CSD027
     C                   EVAL      GISUPP = *BLANKS                                           CSD027
     C                   ELSE                                                                 CSD027
     C                   EVAL      GISUPP = SuppUpd
     C                   END                                                                  CSD027
     C/EXEC SQL                                                                             MD054605
     C+ update SDSVLCTD                                                                     MD054605
     C+  SET GISUPP = :SuppUpd                                                              MD054605
     C+ where GISVAL = :SysValKey                                                           MD054605
     C/END-EXEC                                                                             MD054605
     C                   ENDIF
      *
      ** Update the record
      *
     C**********         UPDATE    @SVALL0                                                  MD054605
     C/EXEC SQL                                                                             MD054605
     C+ update SDSVLXTD                                                                     MD054605
     C+  SET GIVAL = :NewSysVal                                                             MD054605
     C+ where GISVAL = :SysValKey                                                           MD054605
     C/END-EXEC                                                                             MD054605

     C                   SETON                                        LR

     C                   RETURN

     C                   ENDSR

      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON

     C                   RETURN

     C                   ENDSR

