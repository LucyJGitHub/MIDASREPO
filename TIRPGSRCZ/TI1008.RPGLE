     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas TI Retail Account')
      *****************************************************************
      *                                                               *
      *  Midas - Trade Innovation Interface Module                    *
      *                                                               *
      *  TI1008 - Midas TI Retail Account Processing                  *
      *                                                               *
      *  Function:  This program determines wether or not not the     *
      *             boolean 'retail'  is  to be set on                *
      *                                                               *
      *  Phases:                                                      *
      *                                                               *
      *  Called By: TI1010                                            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      *  Prev Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CTI002  *CREATE    Date 23Dec98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CTI002 - Created for Midas/TI Interface Phase 2              *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *****************************************************************
      *
      *
      ** Array containing Copyright statement
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Parameters for TIC0060
      *
     D P#FILE          S             10
     D P#RETR          S              1
      *****************************************************************
      *
     D TFLD            DS
      ** Target field structure
     D  TFNAME                 1     10
     D  TFTYPE                11     11
     D  TFPREC                12     13B 0
     D  TFSCAL                14     15B 0
      *
     D SDATA           DS
      ** Source field data
     D  BBCSSN                 1     10
     D  BBCUST                 1      6
     D  BRCAX                  1      3
     D  A5TIAN                 4      9
     D  A5TIAS                10     12
     D**ACOD****               1      4  0                                                    CGL029
     D  ACOD                   1     10  0                                                    CGL029
     D  ATYP                   1      2
     D  MIDATE                 1      3P 0
     D  TICSID                 1     12
     D  TICBR9                 9     11
     D  A8BRCD                 1      3
     D**CNUM****               1      6  0                                                    CSD027
     D  CNUM                   1      6                                                       CSD027
     D  BRCA                   1      3
     D  CCY                    1      3
     D  ACSQ                   1      2  0
      *
     D TDATA           DS
      ** Target field data
     D  GFCUS                  1      6
     D  GFCLC                  7      9
     D  CUSSTS                 1      1
     D  SCAI46                 1      1
     D  SCAI47                 1      1
     D  SCACT                  1      2
     D  TIDATE                 1      7  0
     D  TISABA                 1      4
     D  TISACO                 5      6
     D  TISALO                 7      8
     D  TISABR                 9     11
     D  A8TIBR                 1      4
     D**TIANO***               1      6  0                                                    CSD027
     D  TIANO                  1      6                                                       CSD027
     D  SCEAN1                 1     25
      * Amendments for CTI002                                                                 CTI002
     D  Retail_All             1     20                                                       CTI002
     D  Retail_1st             1     10                                                       CTI002
      *
      ********************************************************************                    CTI002
      /EJECT                                                                                  CTI002
      ********************************************************************                    CTI002
      *                                                               *                       CTI002
     C     *DTAARA       DEFINE                  LDA
      *                                                               *                       CTI002
     C     *ENTRY        PLIST
     C                   PARM                    TFLD
     C                   PARM                    SDATA
     C                   PARM                    TDATA
      *                                                               *                       CTI002
      ********************************************************************                    CTI002
     C                   CALL      'TIC0060'                            81                    CTI002
     C                   PARM      'ACNXTAB'     P#FILE           10                          CTI002
     C                   PARM                    P#RETR            1                          CTI002
      *                                                                                       CTI002
     C     *IN81         IFEQ      '1'                                                        CTI002
     C     *LOCK         IN        LDA                                                        CTI002
     C                   MOVEL     'TIC0060'     DBFILE                     * DBERROR 003     CTI002
     C                   MOVEL     'TI1010'      DBPGM                                        CTI002
     C                   MOVE      '001'         DBASE                                        CTI002
     C                   OUT       LDA                                                        CTI002
     C                   EXSR      *PSSR                                                      CTI002
     C                   ENDIF                                                                CTI002
      *                                                               *                       CTI002
      *   If length of data TFPREC = 1, then                          *                       CTI002
      *      If table ACNXTAB does not exist                          *                       CTI002
      *      AND BRCSSN (Retail account data passed) non zero, then   *                       CTI002
      *          Move BLANKS to return parameter in target data       *                       CTI002
      *          Set CUSSTS = 1                                       *                       CTI002
      *      endif                                                    *                       CTI002
      *      If table does exist                                      *                       CTI002
      *         Set CUSSTS = 0                                        *                       CTI002
      *      endif                                                    *                       CTI002
      *                                                               *                       CTI002
      *   If length of data TFPREC = 20 then                          *                       CTI002
      *      Move BBCSSN to return field (1st 10 char)                *                       CTI002
      *      Move BLANKS to return field (2nd 10 char)                *                       CTI002
      *   endif                                                       *                       CTI002
      *                                                               *                       CTI002
      *****************************************************************                       CTI002
      *                                                               *                       CTI002
      * If length of data = 1                                         *                       CTI002
     C     TFPREC        IFEQ      1                                                          CTI002
      * If table does not exist                                       *                       CTI002
     C     P#RETR        ifeq      'N'                                                        CTI002
      * If BBCSSN not zeros                                           *                       CTI002
     C     BBCSSN        ifne      *Zeros                                                     CTI002
     C                   move      *blanks       Retail_All                                   CTI002
     C                   move      '1'           CUSSTS                                       CTI002
     C                   else
     C                   move      *blanks       Retail_All                                   CTI002
     C                   move      '0'           CUSSTS                                       CTI002
     C                   endif                                                                CTI002
      *                                                               *                       CTI002
      * If table exists                                               *                       CTI002
     C                   else                                                                 CTI002
     C                   move      *blanks       Retail_All                                   CTI002
     C                   move      '0'           CUSSTS                                       CTI002
      *                                                               *                       CTI002
     C                   endif                                                                CTI002
      *                                                               *                       CTI002
     C                   endif                                                                CTI002
      *                                                               *                       CTI002
      * If length of data = 10                                        *                       CTI002
     C     TFPREC        ifeq      20                                                         CTI002
     C                   move      *blanks       Retail_All                                   CTI002
     C                   movel     BBCSSN        Retail_1st                                   CTI002
     C                   endif                                                                CTI002
      *                                                               *                       CTI002
     C                   seton                                            LR
     C                   RETURN
      *                                                               *                       CTI002
      *****************************************************************
      /EJECT                                                                                  CTI002
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
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   ENDIF
      *
      ************ END PROGRAM *******************************************
     C                   SETON                                        U7U8LR
     C                   RETURN
      ********************************************************************
      *
     C                   ENDSR
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
