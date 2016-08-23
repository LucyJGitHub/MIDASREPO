     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MS Handle a big array of 1 char')
      *****************************************************************
      *                                                               *
      *  Midas - S.W.I.F.T. Direct Link Module                        *
      *                                                               *
      *  MS1910 - Handle a big array of 1 char                        *
      *                                                               *
      *  Function:  This program is used to do Operations on a big    *
      *  array, like clear, filling, scan, subst.                     *
      *                                                               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *  Last Amend No. CFT014  *CREATE    Date 25May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
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
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
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
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Procedures                           ¦
      ** ¦ ==========                           ¦
      ** +--------------------------------------+
 
     D ExecProc        PR                  LIKE(Result)
     D  SRName                             LIKE(FindProc) VALUE
     D  Fact1                              LIKE(Factor1) VALUE
     D  Len1                               LIKE(Length1) VALUE
     D  Fact2                              LIKE(Factor2) VALUE
     D  Len2                               LIKE(Length2) VALUE
 
     D Dberror         PR
     D  File                               LIKE(DBFILE) VALUE
     D  Key                                LIKE(DBKEY) VALUE
     D  Base                               LIKE(DBASE) VALUE
     D  ProcName                           LIKE(PSProcName) VALUE
 
     D FindProc        PR             6
     D  Oper                               LIKE(OperCode) VALUE
     D  Len1                               LIKE(Length1) VALUE
     D  Len2                               LIKE(Length2) VALUE
 
     DFILL             PR
     D Fact1                               LIKE(Factor1) VALUE
     D Len2                                LIKE(Length2) VALUE
 
     DCLRALL           PR
 
     DSCNNN            PR                  LIKE(Result)
     D Fact1                               LIKE(Factor1) VALUE
 
     DSCNNY            PR                  LIKE(Result)
     D Fact1                               LIKE(Factor1) VALUE
     D Len2                                LIKE(Length2) VALUE
 
     DSCNYN            PR                  LIKE(Result)
     D Fact1                               LIKE(Factor1) VALUE
     D Len1                                LIKE(Length1) VALUE
 
     DSCNYY            PR                  LIKE(Result)
     D Fact1                               LIKE(Factor1) VALUE
     D Len1                                LIKE(Length1) VALUE
     D Len2                                LIKE(Length2) VALUE
 
     DSUBYN            PR                  LIKE(Result)
     D Len1                                LIKE(Length1) VALUE
 
     DSUBNY            PR                  LIKE(Result)
     D Len2                                LIKE(Length2) VALUE
 
     DSUBYY            PR                  LIKE(Result)
     D Len1                                LIKE(Length1) VALUE
     D Len2                                LIKE(Length2) VALUE
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      ** Not a named constant but size used as a constant
     D LENSWD          S          32767
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Big array
     D DSSWD           DS
     D SWD                            1    DIM(%LEN(LENSWD))
 
      ** Execute Sub Routine
     D ExecSR          S             21    DIM(9) CTDATA PERRCD(1)
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
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EVAL      RtnCode = *BLANK
     C                   EVAL      Result = ExecProc(
     C                                      FindProc(OperCode:Length1:Length2):
     C                                      Factor1:
     C                                      Length1:
     C                                      Factor2:
     C                                      Length2)
     C
     C
 
     C                   RETURN
      **********************************************************************
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
      ** Factor 1
     C                   PARM                    Factor1         256
      ** Length 1
     C                   PARM                    Length1          15 0
      ** Operation code
      ** - *FILL : fill array
      **    + (I) Factor1 -> variable to put
      **    + (I) Length2 -> position in the array
      ** - *CLEAR_A : clear all the arrays
      ** - *SCAN : search for a argument
      **    + (I) Factor 1 -> comparator
      **    + (I) Length 1 -> string length
      **    + (I) Length 2 -> start
      **    + (O) Result -> position of first occurence
      ** - *SUBST : extract a string
      **    + (I) Length 1 -> length to extract
      **    + (I) Length 2 -> start
      **    + (O) Result -> target string
     C                   PARM                    OperCode         10
      ** Factor 2
     C                   PARM                    Factor2         256
      ** Length 2
     C                   PARM                    Length2          15 0
      ** Result
     C                   PARM                    Result          256
      ** Return code
     C                   PARM                    RtnCode           7
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
 
     C                   ENDSR
 
      *
      /EJECT
      *********************************************************************
      * FindProc - Find the procedure to be executed                      *
      *********************************************************************
     PFindProc         B
     DFindProc         PI             6
     D Oper                                LIKE(OperCode) VALUE
     D Len1                                LIKE(Length1) VALUE
     D Len2                                LIKE(Length2) VALUE
 
     D DsExecSR        DS
     D  ExOper                             LIKE(OperCode)
     D  ExCom1                        1    INZ(';')
     D  ExAftFc1                      1
     D  ExCom2                             LIKE(ExCom1) INZ(';')
     D  ExAftFc2                           LIKE(ExAftFc1)
     D  ExCom3                             LIKE(ExCom1) INZ(';')
 
      ** Indexes
     D  i              S              4  0
 
     C                   EVAL       ExOper = Oper
      ** Is there further argument specified in factor 1 ?
     C                   IF         Len1 <> 0
     C                   EVAL       ExAftFc1 = 'Y'
     C                   ELSE
     C                   EVAL       ExAftFc1 = 'N'
     C                   ENDIF
 
      ** Is there further argument specified in factor 2 ?
     C                   IF         Len2 <> 0
     C                   EVAL       ExAftFc2 = 'Y'
     C                   ELSE
     C                   EVAL       ExAftFc2 = 'N'
     C                   ENDIF
 
     C                   EVAL      i = 1
     C                   DOW       i <= %ELEM(ExecSR)
     C                             AND %SUBST(ExecSR(i):1:15) <> DsExecSR
     C                   EVAL      i = i + 1
     C                   ENDDO
 
     C                   IF        i > %ELEM(ExecSR)
     C                   CALLP     Dberror('ExecSR':DsExecSR:001:PSProcName)
     C                   ENDIF
 
     C                   RETURN    %SUBST(ExecSR(i):16:6)
 
     PFindProc         E
      *********************************************************************
      * ExecProc - Execute the appropriate procedure                      *
      *********************************************************************
     PExecProc         B
     DExecProc         PI                  LIKE(Result)
     D SRName                              LIKE(FindProc) VALUE
     D Fact1                               LIKE(Factor1) VALUE
     D Len1                                LIKE(Length1) VALUE
     D Fact2                               LIKE(Factor2) VALUE
     D Len2                                LIKE(Length2) VALUE
 
     D Res             S                   LIKE(Result)
 
     C                   SELECT
     C                   WHEN      SRName = 'FILL  '
     C                   CALLP     FILL(Fact1:Len2)
 
     C                   WHEN      SRName = 'CLRALL'
     C                   CALLP     CLRALL
 
     C                   WHEN      SRName = 'SCNNN'
     C                   EVAL      Res = SCNNN(Fact1)
 
     C                   WHEN      SRName = 'SCNNY'
     C                   EVAL      Res = SCNNY(Fact1:Len2)
 
     C                   WHEN      SRName = 'SCNYN'
     C                   EVAL      Res = SCNYN(Fact1:Len1)
 
     C                   WHEN      SRName = 'SCNYY'
     C                   EVAL      Res = SCNYY(Fact1:Len1:Len2)
 
     C                   WHEN      SRName = 'SUBNY'
     C                   EVAL      Res = SUBNY(Len2)
 
     C                   WHEN      SRName = 'SUBYN'
     C                   EVAL      Res = SUBYN(Len1)
 
     C                   WHEN      SRName = 'SUBYY'
     C                   Eval      Res = SUBYY(Len1:Len2)
     C                   ENDSL
 
     C                   RETURN    Res
 
     PExecProc         E
      *********************************************************************
      * Dberror  - Data base Error                                        *
      *********************************************************************
     PDberror          B
     DDberror          PI
     D File                                LIKE(DBFILE) VALUE
     D Key                                 LIKE(DBKEY) VALUE
     D Base                                LIKE(DBASE) VALUE
     D ProcName                            LIKE(PSProcName) VALUE
 
     C                   EVAL      RtnCode = '*ERROR'
      *
      ** Data base error in file (file)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  File
     C                   EVAL      DBKEY  =  Key
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  Base
     C                   EVAL      DBMOD  =  PSProcMod
      **--------------------------------------------------------------------------------------------
      ** If module contains multiple procedures, replace 'SR/Subroutine'
      ** text with field PSProc which will be retrieved from PSDS.  Else
      ** write 'SR/subroutine name' to indicate on dump it is not a procedure.
      **              *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
     C                   EVAL      DBPROC =  ProcName
     C                   OUT       LDA
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
     PDberror          E
      *********************************************************************
      * FILL - Fill the array                                             *
      *********************************************************************
     PFILL             B
     DFILL             PI
     D Fact1                               LIKE(Factor1) VALUE
     D Len2                                LIKE(Length2) VALUE
 
     D LengthA         DS
     D Length                              LIKE(Length2)
 
     C                   IF        Len2 > %LEN(LENSWD)
     C                   CALLP     Dberror('MEMORY':LengthA:002:PSProcName)
     C                   ENDIF
     C                   MOVEA     Fact1         SWD(Len2)
 
     PFILL             E
      *********************************************************************
      * CLRALL - Clear all the array                                      *
      *********************************************************************
     PCLRALL           B
     DCLRALL           PI
     C                   CLEAR                   DSSWD
     PCLRALL           E
      *********************************************************************
      * SCNNN - Scan 1                                                    *
      *********************************************************************
     PSCNNN            B
     DSCNNN            PI                  LIKE(Result)
     D Fact1                               LIKE(Factor1) VALUE
 
     D Res             DS
     D Lends                               LIKE(Result)
     D ResNum                         5  0 OVERLAY(Lends)
 
     D LenF1           S              3  0
 
     C     ' '           CHECKR    Factor1       LenF1
     C     Factor1:LenF1 SCAN      DSSWD         ResNum
     C                   RETURN    Res
 
     PSCNNN            E
      *********************************************************************
      * SCNNY - Scan 2                                                    *
      *********************************************************************
     PSCNNY            B
     DSCNNY            PI                  LIKE(Result)
     D Fact1                               LIKE(Factor1) VALUE
     D Len2                                LIKE(Length2) VALUE
 
     D Res             DS
     D Lends                               LIKE(Result)
     D ResNum                         5  0 OVERLAY(Lends)
 
     D LenF1           S              3  0
 
     C     ' '           CHECKR    Factor1       LenF1
     C     Factor1:LenF1 SCAN      DSSWD:Len2    ResNum
     C                   RETURN    Res
     PSCNNY            E
      *********************************************************************
      * SCNYN - Scan 3                                                    *
      *********************************************************************
     PSCNYN            B
     DSCNYN            PI                  LIKE(Result)
     D Fact1                               LIKE(Factor1) VALUE
     D Len1                                LIKE(Length1) VALUE
 
     D Res             DS
     D Lends                               LIKE(Result)
     D ResNum                         5  0 OVERLAY(Lends)
 
     C     Factor1:Len1  SCAN      DSSWD         ResNum
     C                   RETURN    Res
     PSCNYN            E
      *********************************************************************
      * SCNYY - Scan 4                                                    *
      *********************************************************************
     PSCNYY            B
     DSCNYY            PI                  LIKE(Result)
     D Fact1                               LIKE(Factor1) VALUE
     D Len1                                LIKE(Length1) VALUE
     D Len2                                LIKE(Length2) VALUE
 
     D Res             DS
     D Lends                               LIKE(Result)
     D ResNum                         5  0 OVERLAY(Lends)
 
     C     Factor1:Len1  SCAN      DSSWD:Len2    ResNum
     C                   RETURN    Res
     PSCNYY            E
      *********************************************************************
      * SUBYN - Substring 1                                               *
      *********************************************************************
     PSUBYN            B
     DSUBYN            PI                  LIKE(Result)
     D Len1                                LIKE(Length1) VALUE
 
     D Res             S                   LIKE(Result)
     C                   EVAL      Res = %SUBST(DSSWD:1:Len1)
     C                   RETURN    Res
     PSUBYN            E
      *********************************************************************
      * SUBYY - Substring 2                                               *
      *********************************************************************
     PSUBYY            B
     DSUBYY            PI                  LIKE(Result)
     D Len1                                LIKE(Length1) VALUE
     D Len2                                LIKE(Length2) VALUE
 
     D Res             S                   LIKE(Result)
     C                   EVAL      Res = %SUBST(DSSWD:Len2:Len1)
     C                   RETURN    Res
     PSUBYY            E
      *********************************************************************
      * SUBNY - Substring 3                                               *
      *********************************************************************
     PSUBNY            B
     DSUBNY            PI                  LIKE(Result)
     D Len2                                LIKE(Length2) VALUE
 
     D Res             S                   LIKE(Result)
     C                   EVAL      Res = %SUBST(DSSWD:Len2)
     C                   RETURN    Res
     PSUBNY            E
 
** CTDATA ExecSR
*FILL     ;N;Y;FILL
*CLEAR_A  ;N;N;CLRALL
*SCAN     ;N;N;SCNNN
*SCAN     ;N;Y;SCNNY
*SCAN     ;Y;N;SCNYN
*SCAN     ;Y;Y;SCNYY
*SUBST    ;N;Y;SUBNY
*SUBST    ;Y;N;SUBYN
*SUBST    ;Y;Y;SUBYY
