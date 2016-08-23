     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate Customer Number')                    *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLVCSNB   - Validate Customer Number                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. 226364             Date 19Aug14               *
      *  Prev Amend No. MD000091           Date 07MAy13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035  *CREATE    Date 19Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  226364 - Allow accounts to have parent customers. Applied    *
      *           fix 213782.                                         *
      *           Applied for MD021329.                               *
      *  MD000091 - Event Codes Substitution                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAP035 - Midas/ToF Interface                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      ** Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      ** External data structure for customer details file
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External data structure for access programs (long)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External data structure for access programs (very long)                              CSD025
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CSD025
                                                                                              CSD025
      ** DS for Access Objects - short data structure                                         CSD025
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSD025
                                                                                              CSD025
      ** Externally described DS for SAR details                                              CSD025
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSD025
                                                                                              CSD025
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                            MD000091
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
 
      ** Initialization
 
     C                   Move      *BLANK        RetCodeIn
 
     C                   Move      *BLANK        FldNamXAr
     C                   Move      *BLANK        MsgIDXAr
     C                   Move      *BLANK        MsgDtaXAr
     C                   Z-add     0             Idx
 
      *
      * Error if customer is not defined
      *
     C     DDCUSN        IfEq      *Blanks
     C                   Move      'N'           DDCUSNOK
     C                   Add       1             Idx
     C                   Movel     'DDCUSN'      FldNamXAr(Idx)
     C                   Movel     'RE71030'     MsgIdXAr(Idx)
      *
     C                   Else
      *
     C*****              CallB     'AOCUSTR0'                                                 CSD025
     C                   CallB     'AOCUSTR1'                                                 CSD025
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      DDCUSN        @KEY1            10
     C                   Parm      *Blanks       @KYST             7
     C*****SDCUST        Parm      SDCUST        DSSDY                                        CSD025
     C     SDCUST        Parm      SDCUST        DSLDY                                        CSD025
      *
      * Invalid customer
      *
     C     @RTCD         IfNe      *Blanks
     C     BBDTDL        OrNe      0
     C                   Move      'N'           DDCUSNOk
     C                   Add       1             Idx
     C                   Movel     'DDCUSN'      FldNamXAr(Idx)
     C                   Movel     'RE71031'     MsgIdXAr(Idx)
     C                   Else
     C                   Movel     BBCust        DDCUSN
     C                   EndIf
      *
      **If*customer*is*OK,*it*can't*be*a*parent************************                       226364
      **********                                                                              226364
     C*****DDCUSNOk      IfEq      'Y'                                                        226364
     C*****BBPaIn        AndEq     'P'                                                        226364
     C**********         Move      'N'           DDCUSNOK                                     226364
     C**********         Add       1             Idx                                          226364
     C**********         Movel     'DDCUSN'      FldNamXAr(Idx)                               226364
     C**********         Movel     'RE71032'     MsgIdXAr(Idx)                                226364
     C**********         EndIf                                                                226364
      *
     C                   EndIf
      *                                                                                       CSD025
     C     @RTCD         IFEQ      *BLANKS                                                    CSD025
     C     BBDEAC        ANDEQ     'Y'                                                        CSD025
     C     DDACTN        ANDEQ     'I'                                                        CSD025
     C     CSD025        ANDEQ     'Y'                                                        CSD025
      *                                                                                       CSD025
     C                   Move      'N'           DDCUSNOK                                     CSD025
     C                   Add       1             Idx                                          CSD025
     C                   Movel     'DDCUSN'      FldNamXAr(Idx)                               CSD025
     C                   EVAL      MsgIdXAr(Idx) = 'ABM0027'                                  CSD025
     C**********         EVAL      MsgDtaXAr(Idx) = BBCUST                           CSD025 MD000091
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(BBCUST)                   MD000091
      *                                                                                       CSD025
     C                   ENDIF                                                                CSD025
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDCUSNOk      IfEq      'N'
     C                   Eval      RetCodeIn = 'Error'
     C                   EndIf
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *Entry        Plist
      *
      * INPUTS
      *
      ** Return Code
     C                   Parm                    RetCodeIn
      *
      ** Account Screen fields
     C                   Parm                    DDCUSN            6            customer
      *
      ** Action Code field                                                                    CSD025
     C                   Parm                    DDACTN            1                          CSD025
      *                                                                                       CSD025
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *
      ** Customer - OK
     C                   Parm                    DDCUSNOk          1
      *                                                                                       CSD025
      ** Check if CSD025 (Customer De-Activation) is active                                   CSD025
      *                                                                                       CSD025
     C                   CALLB     'AOSARDR0'                                                 CSD025
     C                   PARM      *BLANKS       PRtCd             7                          CSD025
     C                   PARM      '*VERIFY'     POptn             7                          CSD025
     C                   PARM      'CSD025'      PSARD             6                          CSD025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD025
                                                                                              CSD025
     C                   MOVE      'N'           CSD025            1                          CSD025
     C                   IF        PRtCd = *Blanks                                            CSD025
     C                   EVAL      CSD025 = 'Y'                                               CSD025
     C                   ENDIF                                                                CSD025
      *
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
(c) Misys International Banking Systems Ltd. 2001
