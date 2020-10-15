     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2020')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Standing Data Webface Dashboard program')
      *****************************************************************
      *                                                               *
      *  Midas -  Global Processing                                   *
      *                                                               *
      *  GO000200 - Standing Data Webface Dashboard program.          *
      *                                                               *
      *  Function:  This program countsthe number of unauthorised item*
      *             item per API.                                     *
      *                                                               *
      *  Called By: None                                              *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD056648           Date 14Oct20               *
      *  Prev Amend No. AR572523 *CREATE   Date 14Oct20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056648 - Adding pending “Standing Data Authorisation” items*
      *             to Fusion Midas Dashboard.                        *
      *             Fix error on implicit open and count should be    *
      *             alphanumeric.                                     *
      *  AR572523 - Created to count the number of unauthorised items *
      *             per API. (Child: AR572524). Applied for MD-41403. *
      *           - Applied for MD056648.                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of Indicator                           *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
     FGPZONEL2  IF   E           K DISK
     FGPDWNLL0  UF A E           K DISK    USROPN
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D Value           S             50A
     D*CountN**********S              5S 0                                                  MD056648
     D                 DS                                                                   MD056648
     D CountN                  1      5  0                                                  MD056648
     D CountA                  1      5                                                     MD056648
     D LDA           E DS           256    EXTNAME(LDA)
     D SDSTAT        E DS                  ExtName(SDSTAT) DtaAra(SDSTAT)
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D @RUN            S              1

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Read in Installation Data
      *
     C
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
     C                   IN        SDSTAT
     C/COPY GOCPYSRC,GOUPD_PARM
     C                   If        %OPEN(GPDWNLL0)
     C                   CLOSE     GPDWNLL0
     C                   EndIf

     C                   EVAL      Value   = *blanks
     C                   EVAL      CountN  = *zeros
     C     LIBR          Chain     GPZONEL2
     C                   EVAL      System_ID  = ZOMSYS
     C                   EXSR      UpdateCount
     C*******************OPEN      GPDWNLL0                                                 MD056648
     C/COPY GOCPYSRC,GOUPD_DWNL
     C                   CLOSE     GPDWNLL0

     C     ENDPGM        TAG
     C                   EVAL      *INLR = *ON
     C                   Return

      *****************************************************************
      *                                                               *
      *  UpdateCount  - Count number of anauthorise transaction.      *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     UpdateCount   BegSr
     C                   EVAL      COUNTN = *zeros
     C/exec sql
     C+ select count(*) into :COUNTN from SDAULGPD where alfunc =:Extra_Parms
     C/end-exec
     C                   If        SQLCOD <> *ZEROS
     C                   Exsr      *PSSR
     C                   Else
     C*******************Eval      VALUE = %CHAR(COUNTN)                                    MD056648
     C                   Eval      VALUE = COUNTA                                           MD056648
     C                   EndIf
     C                   EndSr

      *****************************************************************
      ******************************************************************
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
      *
     C     *PSSR         BEGSR
      *
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
