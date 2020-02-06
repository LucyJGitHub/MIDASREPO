     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Rtv / Calc next RFT or CCT Number')
      *****************************************************************
      *                                                               *
      *  Midas - Standard subprograms                                 *
      *                                                               *
      *  FTM1012GN - Retrieve the next RFT / CCT reference number     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CFT009             Date 30May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 178751             Date 09May00               *
      *                 178186             Date 09May00               *
      *                 CFT006  *CREATE    Date 15Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT009 - Addition of fields for FT fees and charges          *
      *           Recompile                                           *
      *  178751 - Auto generation of references                       *
      *  178186 - Remove duplicated commit                            *
      *  CFT006 - Funds Transfer addition of MT101 and MT102 messages *
      *                                                               *
      *****************************************************************
 
     FSDFTFRL0  UF   E           K DISK
     F                                     Commit
      * Funds Transfer ICD File
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
     DP_Ref_Ds         DS
     D @@P                     1      1
     D @@Date                  2      7
     D @@P_Ref                 8     13
     D @@Sett                 14     15
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D  Filler0        S              6  0
     D  Filler1        S              7
     D  Filler2        S              8  0
     D  Trns_Type      S              2
     D  Temp_Char      S              8
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   reset                   RetCodeIn
 
      *
      ** Get todays date in format of YYMMDD from ZA3344
      *
     C                   CallB     'ZA3344'
     C                   Parm                    Filler0
     C                   Parm                    Filler1
     C                   Parm                    Filler2
 
      *
      ** Capture date
      *
     C                   movel     Filler2       Temp_Char
     C     6             Subst     Temp_Char:3   @@Date
 
      *
      ** Get Last Reference Number
      *
     C                   Eval      BTFTD = 'FTFR'
     C     BTFTD         CHAIN     SDFTFRL0                           99
      *
      * Database Errror
      *
     C                   If        *In99
     C                   Eval      DBKey  =  BTFTD
     C                   Eval      DBFILE = 'SDFTFRPD'
     C                   Eval      DBPgm  = PSProcPgm
     C                   Eval      Dbase  = 1
     C                   Eval      DBMod  = PSProcMod
     C                   Eval      DBProc = '*Inzsr'
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   Select
     C                   When      Trns_Type = 'RO'
     C                   Eval      Rftltn = Rftltn+1
     C                   Movel     Rftltn        @@P_Ref
     C                   Eval      @@P='A'
     C                   When      Trns_Type = 'RI'
     C                   Eval      Rftltn = Rftltn+1
     C                   Movel     Rftltn        @@P_Ref
     C                   Eval      @@P='B'
     C                   When      Trns_Type = 'BO'
     C                   Eval      Cctltn = Cctltn+1
     C                   Movel     Cctltn        @@P_Ref
     C                   Eval      @@P='C'
     C                   When      Trns_Type = 'BI'
     C                   Eval      Cctltn = Cctltn+1
     C                   Movel     Cctltn        @@P_Ref
     C                   Eval      @@P='D'
     C                   Endsl
 
      *
      ** Update ICD file with new Id
      *
     C                   Update    @BTREE3
     C*******************Commit                                                 178186
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    RetCodeIn
     C                   PARM                    Trns_Type
     C                   PARM                    P_Ref_Ds
 
     C                   Movel     *Blanks       Temp_Char
     C                   Eval      @@P = 'P'
     C*******************Eval      @@Sett='08'                                  178751
     C                   Eval      @@Sett='  '                                  178751
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
