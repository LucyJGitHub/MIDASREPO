     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility details interface controller')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFCIPCTL - LE Facility Details Maintenance.                 *
      *                                                               *
      *  Function: This Program Validates LE Facility Details for     *
      *            Input into the Midas database.                     *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the Facility details fields           *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For D (=Delete) call a separate function to      *
      *              process this Facility and bypass the rest        *
      *              of the validation                                *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD039655           Date 03Sep19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE147             Date 17Oct11               *
      *                 AR787620           Date 10Jun11               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23786           Date 21Apr09               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247549             Date 03May07               *
      *                 246858             Date 04Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239211             Date 31Aug06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9095            Date 21Jul05               *
      *                 CER001             Date 25Apr05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE034             Date 05May03               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3723            Date 19Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 30Oct03               *
      *                 CLE029             Date 04Sep02               *
      *                 CAP073  *CREATE    Date 180302                *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039655 - Facility cannot be rejected.                      *
      *             Pattern fix from MD-29208 and MD-34908.           *
      *           - Applied for MD052591                              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *           Core hooks added:LEFCIPCF01,LEFCIPCD01,LEFCIPC001,  *
      *                            LEFCIPC002,LEFCIPCC01,LEFCIPCC02   *
      *                            LEFCIPC003,LEFCIPCC03              *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CLE147 - Aggregate Facility                                  *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00354                                 *
      *             WNCPYSRC,LEH00315                                 *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23786 - Incorrect values in Previous and Penultimate Date *
      *             fields when Facility amended in WIP (Recompile)   *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247549 - Review delay processing.                            *
      *  246858 - RespMode not correctly passed to LEFCIP1VL.         *
      *  239211 - Recompile over changes in LEFCSPPD.                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9095 - No deletetion of record for LEVFCIMPD and          *
      *            LEVFCINPD                                          *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CLE106 - Syndications Manager                                *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompiled)                                        *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it (Recompile)                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3723 - Recompile due to changes to LEFCSPPD, LEEFCISPD,   *
      *            and LEIFCIPPD.                                     *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter mismatch.                                 *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************
 
      * Valid Facility FM file
     FLEVFCIMPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Valid Facility FN file
     FLEVFCINPD UF A E             DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
     F                                     COMMIT
      * Invalid Facility
     FLEIFCIPPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FLEVFCIML0 IF   E           K DISK
     F                                     RENAME(LEVFCIMD0:LEVFCIMCK0)
     FLEVFCIML1 IF   E           K DISK
     F                                     RENAME(LEVFCIMD0:LEVFCIMCK1)
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
     FLEVFCLX1PDUF A E           K DISK    INFSR(*PSSR) COMMIT                                CER001
     F                                     RENAME(LEVFCIPX6:VFCIPD6)                          CER001
     FLEIFCLX1PDUF A E           K DISK    INFSR(*PSSR) COMMIT                                CER001
     F                                     RENAME(LEIFCIPXD6:IFCIPD6)                         CER001
 
     F/COPY WNCPYSRC,LEFCIPCF01                                                               LLN022
      * Hook to enable non-core files to be included
      *                                                                                      LLN022A
     FLEVFCIPX0 UF A E           K DISK    INFSR(*PSSR) COMMIT                               LLN022A
     F                                     RENAME(LEVFCIX0:VFCIPD0)                          LLN022A
                                                                                             LLN022A
     FLEIFCIPX0 UF A E           K DISK    INFSR(*PSSR) COMMIT                               LLN022A
     F                                     RENAME(LEIFCIX0:IFCIPD0)                          LLN022A
      *                                                                                      LLN022A
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
 
     D/COPY ZACPYSRC,PROCPARMS
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
     D/COPY ZACPYSRC,APICTLARR
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
     D/COPY ZACPYSRC,DTAQCHKDCL
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
 
      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')
 
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
 
     D WArrCmtJob      S             10A   DIM(10)                                            CSC022
      ** Array for Commitment Job Names                                                       CSC022
                                                                                              CSC022
      ** Data structure for SCCMTJOB data area                                                CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITNO                1      3S 0                                                    CSC022
     D  COMITJOBS              4    103                                                       CSC022
                                                                                              CSC022
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(LEFCPPPD)
     D TranInSeco    E DS                  EXTNAME(LEFCSPPD)
      * Valid Facility FM layout
     D ValidFacm     E DS                  EXTNAME(LEVFCIMPD)
     D                                     PREFIX(V_)
      * Valid Facility FN layout
     D ValidFacn     E DS                  EXTNAME(LEVFCINPD)
     D                                     PREFIX(V_)
 
      * (Current) Facility record FM in file Format
     D FacmFilFmt    E DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(FM_)
      * (Current) Facility record FN in file Format
     D FacnFilFmt    E DS                  EXTNAME(FCLTYFN)
     D                                     PREFIX(FN_)
 
      * (Current) Facility in Screen Format - Primary Details
     D CurFcPrim     E DS                  EXTNAME(LEFCPPPD)
     D                                     PREFIX(@)
      * (Current) Facility in Screen Format - Secondary Details
     D CurFcSeco     E DS                  EXTNAME(LEFCSPPD)
     D                                     PREFIX(@)
 
      * Error indicators
     D OKFcPrim      E DS                  EXTNAME(LEEFCIPPD)
     D OKFcSeco      E DS                  EXTNAME(LEEFCISPD)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **   CUSTOMER
      *
     D RegData       E DS                  EXTNAME(LEFCRXPD)                                  CER001
                                                                                              CER001
     D OKFlags       E DS                  EXTNAME(LEEFCLX1PD)                                CER001
                                                                                              CER001
     D NwFCIPFilFmt  E DS                  EXTNAME(LEVFCLX1PD)                                CER001
      *                                                                                       CER001
      ** External DS for LUX extension valid error file                                       CER001
      *                                                                                       CER001
     D ExtData       E DS                  EXTNAME(LEFCEXPD)
      * SD Facility details Extra Data - File (D/B) format
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure
 
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea
 
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area
 
     D                 DS
     D  DDFACR                 1     11
     D  DDCUSNA                1      6
     D  DDFACTA                7      9
     D  DDFCNOA               10     11
      * DS which contains the complete key
                                                                                              CER001
     D                 DS                                                                     CER001
     D DATALUX                 1   1024                                                       CER001
     D  #1CNUM                 1      6                                                       CER001
      *                                                                                       CER001
      ** Facility Customer Number                                                             CER001
      *                                                                                       CER001
     D  #1FACT                 7      9                                                       CER001
      *                                                                                       CER001
      ** Facility Type                                                                        CER001
      *                                                                                       CER001
     D  #1FCNO                10     11                                                       CER001
      *                                                                                       CER001
      ** Facility Sequence Number                                                             CER001
      *                                                                                       CER001
 
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
 
      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
     D Trans5002       S            500A
 
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A
 
      ** Field (500A) to receive the incoming Extra Data                                      CER001
     D RegData500      S            500A                                                      CER001
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
 
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
     D Object          S             10A   INZ('LEFCIPUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
     D CSC011          S              1A   INZ('N')
     D TRANSDTL        S           5800A
     D***PDealNo         S             18A                                                    CGL029
     D***PADealNo        S             18A                                                    CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D CSC022          S              1A   Inz                                                CSC022
     D WSkipCommit     S              1A   Inz                                                CSC022
     D WPtr            S              2S 0 Inz                                                CSC022
 
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list.
     D ClrPgmMsgQ      S              1A   INZ('Y')
 
      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)
 
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepPrim         S              1A   inz('N')
     D RepSeco         S              1A   inz('N')
 
     D ULX004          S              1A                                                      CER001
                                                                                              CER001
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+
     D/COPY WNCPYSRC,LEFCIPCD01                                                               LLN022
      *                                                                                      LLN022A
      ** External DS for LEVFCIPX0                                                           LLN022A
      *                                                                                      LLN022A
     D ValidBOE      E DS                  ExtName(LEVFCIPX0)                                LLN022A
     D                                     Prefix(N)                                         LLN022A
      *                                                                                      LLN022A
      ** External DS for LEEFCIPX0                                                           LLN022A
      *                                                                                      LLN022A
     D OKBOEFlags    E DS                  ExtName(LEEFCIPX0)                                LLN022A
      *                                                                                      LLN022A
      ** External DS for LEVEFCIPX0                                                          LLN022A
      *                                                                                      LLN022A
     D NwFCIPFilFrmt E DS                  ExtName(LEVEFCIPX0)                               LLN022A
     D                                     Prefix(PF)                                        LLN022A
      *                                                                                      LLN022A
      ** DS Structure for DATA                                                               LLN022A
      *                                                                                      LLN022A
     D                 DS                                                                    LLN022A
     D DATA                    1   1024                                                      LLN022A
      *                                                                                      LLN022A
      ** Facility Customer Number                                                            LLN022A
      *                                                                                      LLN022A
     D  BYCNUM               301    306                                                      LLN022A
      *                                                                                      LLN022A
      ** Facility Type                                                                       LLN022A
      *                                                                                      LLN022A
     D  BYFACT               307    309  0                                                   LLN022A
      *                                                                                      LLN022A
      ** Facility Sequence Number                                                            LLN022A
      *                                                                                      LLN022A
     D  BYFCNO               310    311  0                                                   LLN022A
     D  BYFCCY               312    314                                                      LLN022A
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInPrim
     C                   MOVEL     Trans5002     TranInSeco
     C                   MOVEL     Extdata500    Extdata
     C                   MOVEL     RegData500    RegData                                      CER001
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      *  Set user field depending on action
 
     C                   SELECT
 
     C                   WHEN         DDACTN = 'I'
     C                   EVAL         F1IUSR = APMIDUSR
     C                   WHEN         DDACTN = 'X'
     C                   EVAL         F1XUSR = APMIDUSR
     C                   WHEN         DDACTN = 'A'
     C                   EVAL         F1AUSR = APMIDUSR
 
     C                   ENDSL
 
      *  Check if valid Facility details exists
 
     C                   EXSR      ChkValFcip
      *
      *  If valid Faci.det. does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      *  Check if valid Facility exists for Midas Facility Number
 
     C                   EXSR      ChkValMiFc
      *
      *  If valid Facility does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid Facility details file.
 
     C                   EXSR      RESETCYCLE
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
      *
      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
     C                   WHEN         DDACTN = 'I'
      *  Processing for Inserts
     C                   EXSR      ValidateTr
 
     C/COPY WNCPYSRC,LEFCIPC001                                                               LLN022
      *                                                                                       LLN022
      ** If BOE installed, validate fields                                                   LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
      *                                                                                      LLN022A
     C                   IF        Idx = 0                                                   LLN022A
     C                   MOVE      V_FPCNUM      BYCNUM                                      LLN022A
     C                   MOVE      DDFACT        BYFACT                                      LLN022A
     C                   MOVE      DDFCNO        BYFCNO                                      LLN022A
     C                   MOVE      DDFCCY        BYFCCY                                      LLN022A
      *                                                                                      LLN022A
      ** Call Validation Module                                                              LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'LEFCIPVAL1'                                              LLN022A
     C                   PARM                    ACTN              1                         LLN022A
     C                   PARM                    DATA                                        LLN022A
     C                   PARM                    ExtData                                     LLN022A
     C                   PARM                    OKBOEFlags                                  LLN022A
     C                   PARM                    FldNameArr                                  LLN022A
     C                   PARM                    MsgIDArr                                    LLN022A
     C                   PARM                    MsgDtaArr                                   LLN022A
     C                   PARM                    Idx                                         LLN022A
     C                   PARM                    WFldNamArr                                  LLN022A
     C                   PARM                    WMsgIDArr                                   LLN022A
     C                   PARM                    WMsgDtaArr                                  LLN022A
     C                   PARM                    WIdx                                        LLN022A
     C                   PARM                    NwFCIPFilFrmt                               LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   WHEN         DDACTN = 'A'
     C                             OR DDACTN = 'R'
     C                             OR DDACTN = 'C'
      *  Processing for Amends or Changes
 
      * Check for the existence of the replacement character; if this is
      * used, only the changed data has been sent, and all occurrences of
      * the replacement character must be replaced with the corresponding
      * character from the original transaction.
     C                   if        DDACTN = 'A' AND GHSUBS <> *blank
 
     C     GHSUBS        scan      TranInPrim                             99
     C                   if        *in99
     C                   eval      RepPrim = 'Y'
     C                   endif
 
     C     GHSUBS        scan      TranInSeco                             99
     C                   if        *in99
     C                   eval      RepSeco = 'Y'
     C                   endif
 
      ** If any of the flags set above is true, do the data
      ** substution subroutine.
     C                   if        (RepPrim = 'Y' OR RepSeco = 'Y')
     C                   EXSR      DtaSubs
     C                   endif
 
     C                   endif
 
     C                   EXSR      SetupAmd
     C                   EXSR      ValidateTr
                                                                                              LLN022
     C/COPY WNCPYSRC,LEFCIPC002                                                               LLN022
      *                                                                                       LLN022
      ** If BOE installed, validate fields                                                   LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
      *                                                                                      LLN022A
     C                   IF        Idx = 0                                                   LLN022A
     C                   MOVE      V_FPCNUM      BYCNUM                                      LLN022A
     C                   MOVE      DDFACT        BYFACT                                      LLN022A
     C                   MOVE      DDFCNO        BYFCNO                                      LLN022A
     C                   MOVE      DDFCCY        BYFCCY                                      LLN022A
      *                                                                                      LLN022A
      ** Call Validation Module                                                              LLN022A
      *                                                                                      LLN022A
     C                   CALLB     'LEFCIPVAL1'                                              LLN022A
     C                   PARM                    ACTN                                        LLN022A
     C                   PARM                    DATA                                        LLN022A
     C                   PARM                    ExtData                                     LLN022A
     C                   PARM                    OKBOEFlags                                  LLN022A
     C                   PARM                    FldNameArr                                  LLN022A
     C                   PARM                    MsgIDArr                                    LLN022A
     C                   PARM                    MsgDtaArr                                   LLN022A
     C                   PARM                    Idx                                         LLN022A
     C                   PARM                    WFldNamArr                                  LLN022A
     C                   PARM                    WMsgIDArr                                   LLN022A
     C                   PARM                    WMsgDtaArr                                  LLN022A
     C                   PARM                    WIdx                                        LLN022A
     C                   PARM                    NwFCIPFilFmt                                LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   EXSR      ValdateAmd
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP
 
     C     ARERRMOD      IFNE      *BLANK
     C                   EVAL      MQErrlong  = *blank
     C                   MOVEL     ProcErr       MQError
     C                   MOVE      ARERRMOD      MQError          28
     C                   MOVEL     MQError       MQErrlong
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn         10
     C                   PARM                    MQErrlong       132
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
     C                   RETURN
 
     C                   ELSE
 
      *  Processing for Error checking/write to database
     C                   EXSR      CheckWrite
 
      *  If valid, send data queue entry to prompt DB update program
     C     Idx           IFEQ      0
     C                   EVAL      ObjType = '*DTAARA'
      *  Check if update program active using Allocate Object API
      *  No prompting necessary if program is running
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *BLANK        Return
 
     C     Return        IFEQ      *BLANK
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'.
      ** message to the data queue if there are not.
     D/COPY ZACPYSRC,DTAQCHK
      **--------------------------------------------------------------------------------------------
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValFcip - Routine to check if valid Facility details exist *
      *                                                               *
      *****************************************************************
     C     ChkValFcip    BEGSR
 
 
      * Check for Facility on Valid file
     C     ApFoTranid    CHAIN     LEVFCIML0                          99
 
      * If record found...
     C     *IN99         IFEQ      '0'
 
      * ..delay, then repeat check
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
 
     C     ApFoTranid    CHAIN     LEVFCIML0                          99
     C                   END                                                                  247549
 
      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFACR'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValMiFc - Routine to check if valid Facility exists for    *
      *    Midas Facility reference                                   *
      *                                                               *
      *****************************************************************
 
     C     ChkValMiFc    BEGSR
 
      ** Key list for file LEVFCIML1
     C     KMIFAC        KLIST
     C**********         KFLD                    KCNUM             6 0                        CSD027
     C                   KFLD                    KCNUM             6                          CSD027
     C                   KFLD                    KFACT             3 0
     C                   KFLD                    KFCNO             2 0
      *
      * If (numeric) Midas Customer number supplied
 
     C                   TESTN                   DDCSSN               9898
      *
     C     *IN98         IFEQ      *OFF
      * If not numeric, retrieve Midas Customer number supplied
     C                   CALLB     'AOCUSTR1'
      *
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCSSN        @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C*
     C     @RTCD         IFNE      *BLANKS
     C     @KYST         OREQ      '*ERROR '
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFACR'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ELSE
     C                   MOVEL     *BLANKS       DDCUSN            6
     C                   MOVEL     BBCUST        DDCUSN
     C                   END
      *
     C                   ELSE
     C                   MOVEL     DDCSSN        DDCUSN
     C                   ENDIF
 
      * If (numeric) Midas Facility type supplied
 
     C                   TESTN                   DDFACT               9797
 
      * If (numeric) Midas Facility sub-type supplied
 
     C                   TESTN                   DDFCNO               9696
 
     C     DDCSSN        IFNE      *BLANKS
     C     *IN97         ANDEQ     '1'
     C     *IN96         ANDEQ     '1'
 
      * Check for Facility on Valid file
     C                   MOVEL     DDCUSN        KCNUM
     C                   MOVEL     DDFACT        KFACT
     C                   MOVEL     DDFCNO        KFCNO
     C     KMIFAC        CHAIN     LEVFCIML1                          99
 
      * If record found...
     C     *IN99         IFEQ      '0'
 
      * ..delay, then repeat check
     C**********         CALLB     'ZACDELAY'                                                 247549
     C                   Z-ADD     1             COUNT             2 0                        247549
     C     *IN99         DOWEQ     '0'                                                        247549
     C     COUNT         ANDLE     10                                                         247549
     C                   ADD       1             COUNT                                        247549
     C                   CALLB     'ZACDELAY1'                                                247549
 
     C     KMIFAC        CHAIN     LEVFCIML1                          99
     C                   END                                                                  247549
 
      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFACR'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    Facility  supplied                                         *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)
      *  if insert
      *  if not insert and Midas transaction ID is not present
      * Otherwise
      *  Set retrieve mode to blank  (Access using Midas transaction ID).
      *
     C                   IF        GHSUBS <> *blank
     C     GHSUBS        SCAN      TranInPrim    SubForTRNN        2 0
     C                   ENDIF
     C                   IF        DDACTN = 'I'
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C     DDFACT        IFEQ      *BLANK
     C                   MOVEL     '*FRONT'      ModeofOp
     C                   ELSE
     C                   MOVEL     '      '      ModeofOp
     C                   ENDIF
     C                   ENDIF
 
      * Validate action code versus transaction IDs supplied
      * The Facility in file format from the LE database is retrieved
      * as well.
 
     C                   RESET                   ReturnCode
     C                   MOVEL     APUSERID      APFOTranUs
 
     C                   CALLB     'LEFCIPRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    ReturnCode
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM                    APRESPMODE        1
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      *
      * Front Office User
     C                   PARM                    APFOTranUs       16
      *
      * (Midas) Facility Reference Number
     C                   PARM                    DDCSSN
     C                   PARM                    DDFACT
     C                   PARM                    DDFCNO
     C                   PARM                    DDBRCA
                                                                                            MD039655
      ** Reject action                                                                      MD039655
                                                                                            MD039655
     C                   PARM      *BLANK        @ACTRV            1                        MD039655
     C/COPY WNCPYSRC,LEH00354
      *
      * OUTPUTS
      *
      * (Current) Facility FM in file format
     C                   PARM                    FacmFilFmt
      *
      * (Current) Facility FN in file format
     C                   PARM                    FacnFilFmt
      *
      * OK - Action code
     C                   PARM                    OKACTN            1
      *
      * OK - Customer Number
     C                   PARM                    OKCSSN            1
      *
      * OK - Facility type
     C                   PARM                    OKFACT            1
      *
      * OK - Facility sub type
     C                   PARM                    OKFCNO            1
     C/COPY WNCPYSRC,LEH00315
      *
      * Reactivation indicator
     C                   PARM                    WREAC             1
      *
      * New Expiry date
     C                   PARM                    WNDTEX            5
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments and changes.                                 *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
 
      * For Amends, put the complete (pre-existing) Facility into the Valid
      *  file record - fields in this will be updated during processing
 
     C                   MOVE      FacmFilFmt    ValidFacm
     C                   MOVE      FacnFilFmt    ValidFacn
 
      * For Amends, convert the Facility to screen format
 
     C                   CALLB     'LEFCIPCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeIn
      *
      * Facility - file formats
     C                   PARM                    ValidFacm
     C                   PARM                    ValidFacn
      *
      * Output parameters
      *
      * Facility Details - screen formats
     C                   PARM                    CurFcPrim
     C                   PARM                    CurFcSeco
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      * ValidateTr - Routine to validate the main transaction details  *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR
 
      * Validate Facility Primary details
 
     C                   EXSR      ValdFcPrim
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
 
      * Validate Facility Secondary details
 
     C                   EXSR      ValdFcSeco
      *
      *  If error in validation, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      EValidTr
     C                   END
      *                                                                                       CER001
      ** Validate LUX Extension file                                                          CER001
      *                                                                                       CER001
     C                   IF        ULX004  = 'Y'                                              CER001
     C                   EXSR      ValdLux                                                    CER001
      *                                                                                       CER001
      ** If error in validation, fail this input                                              CER001
      *                                                                                       CER001
     C                   IF        Idx <> 0                                                   CER001
     C                   GOTO      EvalidTr                                                   CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdFcPrim - Validate Facility Primary details                *
      *                                                               *
      *****************************************************************
     C     ValdFcPrim    BEGSR
 
     C                   CALLB     'LEFCIP1VL'
 
      * INPUTS
 
      * Response mode
     C**********         PARM                    RespMode          1                          246858
     C                   PARM                    APRESPMODE                                   246858
      * Mode
     C                   PARM                    ModeOfop
      ** Customer Primary Details
     C                   PARM                    TranInPrim
      ** Customer Secondary Details                                                           CLE106
     C                   PARM                    TranInSeco                                   CLE106
      ** Facility FM File format
     C                   PARM                    FacmFilFmt
      ** Facility FN File format
     C                   PARM                    FacnFilFmt
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      * CLE002
     C                   PARM                    CLE002
      * CLE005
     C                   PARM                    CLE005            1
      * CLE007
     C                   PARM                    CLE007            1
      * CLE014
     C                   PARM                    CLE014            1
 
      * Front office inputs (if mode = 'B' or ModeOfop = FRONT)
     C                   PARM                    F1PCOB            3
     C                   PARM                    F1TNRF           15
     C                   PARM                    F1IUSR           10
     C                   PARM                    F1XUSR           10
     C                   PARM                    F1AUSR           10
      * Customer Extra Data file data
     C                   PARM                    ExtData
     C                   PARM      *BLANK        @ACTRV                                     MD039655
      * OUTPUTS
 
      *
      ** Facility Primary Details OK inds
     C                   PARM                    OKFcPrim
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Valid Facility FM layout (DS) from/to caller
     C                   PARM                    ValidFacm
 
      * Valid Facility FN layout (DS) from/to caller
     C                   PARM                    ValidFacn
 
      * Facility amount has changed
     C                   PARM                    FacAmChg          1
 
      * Table OAM to be updated
     C                   PARM                    UpdOam            1
 
      * Start date used in the other validation module
     C                   PARM                    W#DTAP            5
 
      * Expiry date used in the other validation module
     C                   PARM                    W#DTEX            5
 
      * Facility decimal places used in the other validation module
     C                   PARM                    W#NBDP            1
 
      * CA currency used in the other validation module
     C                   PARM                    WCACCY            3
 
      * Facilty amount
     C                   PARM                    W#FAMT           13 0
 
      * Account officer to default
     C                   PARM                    WBLACF            1
      * Credit Agreement Change Flag                                                          CLE147
     C                   PARM                    CADetails        33                          CLE147
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdFcSeco - Validate Facility Secondary details              *
      *                                                               *
      *****************************************************************
     C     ValdFcSeco    BEGSR
 
     C                   CALLB     'LEFCIP2VL'
 
      * INPUTS
 
      * Response mode
     C                   PARM                    RespMode          1
      ** Facility Primary Details
     C                   PARM                    TranInPrim
      ** Facility Secondary Details
     C                   PARM                    TranInSeco
      * Facility - file formats
     C                   PARM                    FacmFilFmt
     C                   PARM                    FacnFilFmt
      * Front Office Transaction ID
     C                   PARM                    APFOTranID       20
      * Start date
     C                   PARM                    W#DTAP
      * Expiry date
     C                   PARM                    W#DTEX
      * Reactivation indicator
     C                   PARM                    WREAC
      * New Expiry date
     C                   PARM                    WNDTEX
      * Facility decimal places
     C                   PARM                    W#NBDP
      * OK indicator - field TRCA
     C                   PARM                    DDTRCAOK
      * OK indicator - field CAFT
     C                   PARM                    DDCAFTOK
      * OK indicator - field CAFN
     C                   PARM                    DDCAFNOK
      * CA currency used in the other validation module
     C                   PARM                    WCACCY
      * Facilty amount
     C                   PARM                    W#FAMT
      * Account officer to default
     C                   PARM                    WBLACF
      * Particiapnt Fclty indicator
     C                   PARM                    FM_PRTR
      * Customer Extra Data file data
     C                   PARM                    ExtData
      * CLE005
     C                   PARM                    CLE005            1
      * CLE006
     C                   PARM                    CLE006
      * CLE007
     C                   PARM                    CLE007            1
      * CLE014
     C                   PARM                    CLE014            1
      * CSC011
     C                   PARM                    CSC011            1
      * CEU013
     C                   PARM                    CEU013            1
                                                                                            MD039655
      ** Reject Action Code                                                                 MD039655
                                                                                            MD039655
     C                   PARM      *BLANK        @ACTRV                                     MD039655
 
      * OUTPUTS
      *
      ** Facility Primary Details OK inds
     C                   PARM                    OKFcSeco
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Valid Facility FN layout (DS) from/to caller
     C                   PARM                    ValidFacm
 
      * Valid Facility FN layout (DS) from/to caller
     C                   PARM                    ValidFacn
      * Facility amount has changed                                                           222373
     C                   PARM                    FacAmChg          1                          222373
      * Table OAM to be updated                                                               222373
     C                   PARM                    UpdOam            1                          222373
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * ValdLux - Validate Facility Extention Details                 *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     ValdLux       BEGSR                                                                CER001
                                                                                              CER001
     C                   MOVE      DDCUSN        #1CNUM                                       CER001
     C                   MOVE      DDFACT        #1FACT                                       CER001
     C                   MOVE      DDFCNO        #1FCNO                                       CER001
                                                                                              CER001
     C                   CALLB     'LEFCIP3VL'                                                CER001
     C                   PARM                    ACTN              1                          CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OKFlags                                      CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIDArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIDArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    NwFCIPFilFmt                                 CER001
                                                                                              CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *    are amendable.                                             *
      *                                                               *
      *****************************************************************
     C     ValdateAmd    BEGSR
      *
      ** This subroutine calls a procedure which checks whether it
      ** was valid to Amend or Change any of the fields which have been
      ** altered.  Some are never amendable and some are amendable depending
      ** on the Action Code - "A" for Amend.
 
      ** To determine what fields have changed, the current fields
      ** on file must be converted to a 'screen' format.
 
      ** These fields are then compared with the fields on the input
      ** transaction.
 
      ** Any errors detected by the called procedure take precedence
      ** over any errors found during the validation of the complete
      ** transaction.  The errors from the called procedure are kept
      ** separately and, if any are found, these errors will REPLACE
      ** the normal validation errors.
 
     C                   CALLB     'LEFCIPAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Incoming Facility in Screen Format :
 Form * - Primary Details
      * - Secondary Details
     C                   PARM                    TraninPrim
     C                   PARM                    TraninSeco
      *
      * (Current) Facility in Screen Format :
 Form * - Primary Details
      * - Secondary Details
     C                   PARM                    CurFcPrim
     C                   PARM                    CurFcSeco
      *
      * Facility - file formats
     C                   PARM                    ValidFacm
     C                   PARM                    ValidFacn
      *
      * CLE005
     C                   PARM                    CLE005
      * CLE006
     C                   PARM                    CLE006
      * CLE007
     C                   PARM                    CLE007
      * CLE008
     C                   PARM                    CLE008
      * Screen to validate - if blank both screens will be validated
     C                   PARM      ' '           SCREEN            1
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    OKFcPrim
     C                   PARM                    OKFcSeco
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
 
      ** If any errors overwrite previous error information
 
     C                   IF        AmIdx <> 0
     C                   MOVEA     AmMsgIdArr    MsgidArr
     C                   MOVEA     AmFldNamAr    FldNameArr
     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Check/Write - Routine to control checking of error status and *
      *    sending of messages/writing to the database                *
      *                                                               *
      *****************************************************************
 
     C     CheckWrite    BEGSR
 
      *  If no errors were found:
      *     - set up additional data
      *     - write a record to the Valid file
      *     - use std message handler to report Facility status
      *  If any errors were found:
      *     - write a record to the Invalid file
      *     - call the message handler to pass the errors back
      *     - use std message handler to report trade status
      *  The index to the error arrays is checked for presence/absence of
      *   errors
†††††
††††† ** +--- Note for a later release -------------------------------+
††††† ** ¶                                                            ¶
††††† ** ¶ At a later date this routine will have to cater for        ¶
††††† ** ¶ warning messages.  The following logic will have to be     ¶
††††† ** ¶ inserted before "If no errors were found", in the          ¶
††††† ** ¶ above comments (and the code):                             ¶
††††† ** ¶                                                            ¶
††††† ** ¶ If 'Ignore warning messages' (from API ICD) is 'N', AND    ¶
††††† ** ¶ any warning messages were returned (WIdx <> 0)             ¶
††††† ** ¶                                                            ¶
††††† ** ¶ -†††If errors exist                                        ¶
††††† ** ¶†††††-†††††Add the warning array index to the error array   ¶
††††† ** ¶†††††††††††index                                            ¶
††††† ** ¶†††††-†††††Append the contents of the warning arrays to the ¶
††††† ** ¶†††††††††††end of the error arrays                          ¶
††††† ** ¶ -†††Else                                                   ¶
††††† ** ¶ ††††-†††††Set the error array index equal to the warning   ¶
††††† ** ¶†††††††††††array index                                      ¶
††††† ** ¶†††††-†††††Copy the contents of the warning arrays to the   ¶
††††† ** ¶†††††††††††error arrays                                     ¶
††††† ** ¶ -†††Endif                                                  ¶
††††† ** ¶                                                            ¶
††††† ** ¶ Endif                                                      ¶
††††† ** ¶                                                            ¶
††††† ** ¶ Note that the "If errors exist ... Else ... " block above  ¶
††††† ** ¶ can probably be implemented unconditionally (ie the same   ¶
††††† ** ¶ logic will apply whether errors exist as well as warnings  ¶
††††† ** ¶ or not).  It is shown in the above form for clarity.       ¶
††††† ** ¶                                                            ¶
††††† ** +------------------------------------------------------------+
 
 
     C                   IF        Idx = 0
 
     C                   EXSR      SETUPVALID
     C                   WRITE     LEVFCIMD0
     C                   WRITE     LEVFCIND0
 
     C/COPY WNCPYSRC,LEFCIPCC01                                                               LLN022
      *                                                                                       LLN022
      ** If LLN007 is on, write record to valid extension file                               LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   EVAL      LVCNUM = V_FPCNUM                                         LLN022A
     C                   EVAL      LVFACT = V_FPFACT                                         LLN022A
     C                   EVAL      LVFCNO = V_FPFCNO                                         LLN022A
     C                   EVAL      LVEURO = PFLVEURO                                         LLN022A
     C                   EVAL      LVTMST = TimeStamp                                        LLN022A
     C                   EVAL      LVAFRT = APFOTRANID                                       LLN022A
     C                   EVAL      LVREPA = APRprLocn                                        LLN022A
     C                   WRITE     VFCIPD0                                                   LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                       CER001
      ** If ULX004 is on, write record to valid extension file                                CER001
      *                                                                                       CER001
     C                   IF        ULX004  = 'Y'                                              CER001
     C                   EVAL      LVFOID  = APFOTranID                                       CER001
     C                   EVAL      LVRPLC  = APRprLocn                                        CER001
     C                   EVAL      LVTMSP  = TimeStamp                                        CER001
     C                   WRITE     VFCIPD6                                                    CER001
     C                   ENDIF                                                                CER001
     C                   EXSR      CallMsgHdl
 
     C                   ENDIF
 
 
     C     Idx           IFGT      0
     C                   EXSR      SETUPINVAL
      *
      * Only write to invalid files if repair in back office
     C                   IF        APRprLocn = 'B'
 
     C                   WRITE     LEIFCIPD0
 
      ** Write all invalid records to the support log file
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
     C                   EVAL      TRANSDTL = TranInPrim +
     C**********                              TranInSeco                                      CER001
     C                                        TranInSeco + Regdata                            CER001
 
     C                   EVAL      APTGTTYPE  = 'LEFCIP'
     C                   EVAL      PDealNo = DDCSSN + DDFACT +
     C                                       DDFCNO
 
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    HeadIn
     C                   PARM                    TRANSDTL
     C                   PARM                    Timestamp
     C                   PARM                    PDealNo
     C                   PARM      *BLANKS       PADealNo
 
      ** Database error
 
     C                   IF        RetCodeOut <> *BLanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = PDealNo
     C                   EVAL      DBFILE = 'APLOGTRAN'
     C                   EVAL      DBASE = 901
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
                                                                                              LLN022
     C/COPY WNCPYSRC,LEFCIPCC02                                                               LLN022
      *                                                                                       LLN022
      ** If LLN007 is on, write to BOE invalid extension file                                LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   MOVE      V_FPCNUM      LICNUM                                      LLN022A
     C                   MOVE      DDFACT        LIFACT                                      LLN022A
     C                   MOVE      DDFCNO        LIFCNO                                      LLN022A
     C                   MOVE      TimeStamp     LITMST                                      LLN022A
     C                   MOVE      LEUROX        LIEURO                                      LLN022A
     C                   MOVE      APFOTRANID    LIAFRT                                      LLN022A
     C                   MOVE      APRprLocn     LIREPA                                      LLN022A
     C                   WRITE     IFCIPD0                                                   LLN022A
     C                   ENDIF                                                               LLN022A
 
     C                   ENDIF
 
      *
      ** IF ULX004 is on, write to LUX invalid extension file                                 CER001
      *
     C                   IF        ULX004  = 'Y'
     C                   MOVE      LSUBR         LISUBR                                       CER001
     C                   MOVE      LMOBL         LIMOBL                                       CER001
     C                   MOVE      LDGRI         LIDGRI                                       CER001
     C                   MOVE      APFOTRANID    LIFOID                                       CER001
     C                   MOVE      Timestamp     LITMST                                       CER001
     C                   WRITE     IFCIPD6                                                    CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C                   EXSR      CallMsgHdl
 
     C                   ENDIF
 
      *   COMMIT data if either of the following is true:                                     CSC022
      *     1. Commitment Control Changes switch is OFF; or                                   CSC022
      *     2. Commitment Control Changes switch is ON and                                    CSC022
      *        this particular job is not included in the                                     CSC022
      *        commitment jobs in data area SCCMTJOB                                          CSC022
     C                   If        CSC022  = 'N' or                                           CSC022
     C                             (CSC022 = 'Y' and WSkipCommit = 'N')                       CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *    updated during each run of this program                    *
      *                                                               *
      *****************************************************************
     C     RESETCYCLE    BEGSR
 
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx
 
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx
 
     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx
 
     C                   RESET                   FldNoArr
 
     C                   CLEAR                   CurFcPrim
     C                   CLEAR                   CurFcSeco
 
     C                   MOVE      *ALL'Y'       OKFcPrim
     C                   MOVE      *ALL'Y'       OKFcSeco
 
     C                   CLEAR                   ValidFacm
     C                   CLEAR                   ValidFacn
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPINVAL - Set up additional fields that are needed on the  *
      *      Invalid file record.                                     *
      *                                                               *
      *****************************************************************
 
     C     SETUPINVAL    BEGSR
 
      * Include Header fields that need to be o/p to the Invalid files
 
     C                   EVAL      DDFOtranID = APFOTranID
     C                   EVAL      DDFOAsocID = APFOAsocID
     C                   EVAL      DDRprLocn  = APRprLocn
     C                   EVAL      DDTMESTMP = TimeStamp
     C                   EVAL      F1TNRF     = APFOTranID                                   BUG9095
 
     C                   EVAL      TranStatus = 'F'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
 
      * For Reversed or Closure or Authorisation
      * put the complete (pre-existing) Facility
      *  into the Valid file record
     C                   IF           DDACTN = 'R' OR DDACTN = 'C'
     C                                OR DDACTN = 'X'
     C                   MOVE      FacmFilFmt    ValidFacm
     C                   MOVE      FacnFilFmt    ValidFacn
     C                   ENDIF
 
      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      V_FPCHTP = DDACTN
 
      * Include Header fields that need to be o/p to the Valid file
     C     APFOTranID    Ifeq      *Blank
     C                   MOVEL     V_FPPCRF      V_FPFRNT
     C                   Else
     C                   EVAL      V_FPFRNT = APFOTranID
     C                   EVAL      V_FPPCRF = APFOTranID                                     BUG9095
     C                   EndIf
     C                   EVAL      V_FPAFRT = APFOAsocID
     C                   EVAL      V_FPREPA = APRprLocn
     C                   EVAL      V_FPSTMP = TimeStamp
 
     C                   EVAL      TranStatus = 'S'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CallMsgHdl - Call the Message Handling module                 *
      *                                                               *
      *****************************************************************
 
     C     CallMsgHdl    BEGSR
 
      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors
 
     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax
 
     C                   IF        FldNameArr(Ix) <> *blanks
 
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
 
     C                   ELSE
 
     C                   LEAVE
 
     C                   ENDIF
 
     C                   ADD       1             Ix
 
     C                   ENDDO
 
     C                   RESET                   ReturnCode
 
     C                   EVAL      PTranid  = DDCUSN +  DDFACT
     C                             + DDFCNO
 
     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM      *BLANK        ReturnCode
      ** Deal repair location (1A, from caller)
     C                   PARM                    APRprLocn
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    APCnfValFO
      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
     C                   PARM                    MsgIDArr
      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArr
      ** List of field names (Array of <ArrayMax>x10A names - from caller)
     C                   PARM                    FldNameArr
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      ** Front office transaction identifier (20A, from caller)
     C                   PARM                    APFOTranID
      ** Midas module ID (2A)
     C                   Parm                    ModuleID
      ** Midas transaction ID (20A, from caller)
     C                   PARM                    PTranID          20
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    TranStatus
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRespMode
      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      ** Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      ** The MQSeries queue to send replies to
     C                   PARM                    APRpyQueue
      ** The transaction's timestamp
     C                   PARM                    TimeStamp
      ** Additional message files to check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MsgFArray
      ** Whether or not to clear the program message queue (1A)
     C                   PARM                    ClrPgmMsgQ
 
     C                   ENDSR
 
      *****************************************************************
      /eject
      *****************************************************************
      *                                                               *
      * DtaSubs - Data Substitution                                   *
      *                                                               *
      *****************************************************************
 
     C     DtaSubs       begsr
 
      ** Convert file fields to screen format
     C                   reset                   ReturnCode
     C                   CALLB     'LEFCIPCVT'
      * Return Code
     C                   PARM                    ReturnCode
      * Input parameters
      * Facility - file formats
     C                   PARM                    FacmFilFmt
     C                   PARM                    FacnFilFmt
      *
      * Output parameters
      * Facility Details - screen formats
     C                   PARM                    CurFcPrim
     C                   PARM                    CurFcSeco
 
      ** Substitute the data for the various parts of the transaction,
      ** dependent on the flags that were set earlier.
 
     C                   if        RepPrim = 'Y'
 
     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
 
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInPrim    IncData        2000
      * Current Data
     C                   PARM      CurFcPrim     CurData        2000
 
     C                   MOVEL     IncDATA       TranInPrim
 
     C                   endif
 
     C                   if        RepSeco = 'Y'
 
     C                   clear                   IncData
     C                   clear                   CurData
     C                   RESET                   ReturnCode
 
     C                   CALLB     'APDTASUBS'
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM                    GHSUBS
      * Incoming Data
     C                   PARM      TranInSeco    IncData
      * Current Data
     C                   PARM      CurFcSeco     CurData
 
     C                   MOVEL     IncDATA       TranInSeco
 
     C                   endif
 
     C                   endsr
      *****************************************************************
      /EJECT
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Common header information (DS) from source system
     C                   PARM                    HeadIn
      * Transaction information
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002
     C                   PARM                    RegData500                                   CER001
     C                   PARM                    ExtData500
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      ** Initialize SAR work flag and Commit flag                                             CSC022
     C                   Eval      CSC022      = 'N'                                          CSC022
     C                   Eval      WSkipCommit = ' '                                          CSC022
      *                                                                                       CSC022
      ** Determine if Commitment Control Changes for MidasPlus                                CSC022
      ** (CSC022) is installed                                                                CSC022
      *                                                                                       CSC022
     C                   Call      'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      PSARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      **                                                                                      CSC022
      *                                                                                       CSC022
      ** If feature is on, set up SAR work flag                                               CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *Blanks                                            CSC022
     C                   Eval      CSC022      = 'Y'                                          CSC022
     C                   Eval      WSkipCommit = 'N'                                          CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        COMITNO  <> 0                                              CSC022
     C                   MoveA     COMITJOBS     WArrCmtJob                                   CSC022
     C                   Eval      WPtr = %LookUp(PSJobName:WArrCmtJob)                       CSC022
     C                   If        WPtr > 0                                                   CSC022
     C                   Eval      WSkipCommit = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** else, database error (return code other than *NRF)                                   CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> '*NRF   '                                         CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   MoveL     'LEFCIPCTL'   DBPGM                                        CSC022
     C                   MoveL     'SCSARDPD'    DBFILE                                       CSC022
     C                   MoveL     'CSC022'      DBKEY                          ************* CSC022
     C                   Z-Add     902           DBASE                          * DBASE 902 * CSC022
     C                   Out       LDA                                          ************* CSC022
     C                   ExSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022
                                                                                              CSC022
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages
     C                   EVAL      #MsgFile     = 'LERMSGF '
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'Y2USRMSG'
 
     C/COPY WNCPYSRC,LEFCIPC003                                                               LLN022
      *                                                                                       LLN022
      **  Add GBBYUSRMSG to MsgFArray if BOE installed                                       LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   EVAL      MsgFArray (%LookUp(*Blanks:MsgFArray)) =                  LLN022A
     C                             'GBBYUSRMSG'                                              LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'LE'
 
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
 
      ** Determine if CLE002 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE002            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE002
     C                   ENDIF
 
      ** Determine if CLE005 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE005            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE005
     C                   ENDIF
 
      ** Determine if CLE006 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE006            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE006
     C                   ENDIF
      *
      ** Determine if CLE007 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE007            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE007
     C                   ENDIF
 
      ** Determine if CLE008 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE008'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE008            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE008
     C                   ENDIF
      *
      ** Determine if CLE014 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE014            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE014
     C                   ENDIF
      *
      ** Determine if CSC011 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CSC011            1
     C                   ELSE
     C                   MOVEL     'Y'           CSC011
     C                   IN        SC24X7
     C                   IN        SDSTAT
 
     C                   ENDIF
      *
      ** Determine if CEU013 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU013'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CEU013            1
     C                   ELSE
     C                   MOVEL     'Y'           CEU013
     C                   ENDIF
     C/COPY WNCPYSRC,LEFCIPCC03                                                               LLN022
      *                                                                                      LLN022A
      ** Access SAR details file to determine if LLN007                                      LLN022A
      ** Bank of England Yellow Book Changes is installed.                                   LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN007            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       @RTCD                                       LLN022A
     C                   PARM      '*VERIFY'     @OPTN                                       LLN022A
     C                   PARM      'LLN007'      @SARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
      ** Switchable Feature LLN007 is *ON                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *Blanks                                           LLN022A
     C                   EVAL      LLN007 = 'Y'                                              LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                       CER001
      ** Determine if ULX004 is installed                                                     CER001
      *                                                                                       CER001
     C                   EVAL      ULX004  = 'N'                                              CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX004'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
                                                                                              CER001
     C                   IF        @RTCD   = *BLANK                                           CER001
     C                   EVAL      ULX004  = 'Y'                                              CER001
      *                                                                                       CER001
      ** Do not process lux extension details when Lux Return indicator is                    CER001
      ** not set to 'Y'                                                                       CER001
      *                                                                                       CER001
     C                   IF         BGLRIN <> 'Y'                                             CER001
     C                   EVAL       ULX004 = 'N'                                              CER001
     C                   ENDIF                                                                CER001
     C                   ELSEIF    @RTCD  <> '*NRF'                                           CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBPGM   = 'LEFCIPCTL'                                      CER001
     C                   EVAL      DBFILE  = 'SCSARDPD'                                       CER001
     C                   EVAL      DBKEY   = 'ULX004'                                         CER001
     C                   EVAL      DBASE   = 903                                              CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *
      ** Set up the name of the server/database updater data queue.
     C                   EVAL      DtaQName = 'APFCIPDTQ'
 
     C* Override file
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
** ##OX1
OVRDBF FILE(FCLTYXFN) TOFILE(FCLTY) SHARE(*NO)
