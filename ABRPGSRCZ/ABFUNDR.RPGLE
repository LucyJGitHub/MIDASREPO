     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Internal Funding Deals retrieve a record')    *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABFUNDR - Internal Funding Deals retrieve a record           *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 261140             Date 16Sep09               *
      *                 CAP191             Date 12May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 05Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  261140 - Missing Front Office ID / Assoc Front Office ID     *
      *  CAP191 - MQ Enabling of FUND and EXTR APIs                   *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for general ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External DS for dealing details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D  QQAccd1      E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External DS SC Switchable Features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure                                   CGL029
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
                                                                                              CGL029
      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------
 
     D FUNDScnFmt    E DS                  EXTNAME(ABFUNDPD)
      * Internal Funding Deals in screen format
 
     D ExtData       E DS                  EXTNAME(ABFUEXPD)                                  CAP191
      * Internal Funding Deals Extra Data Layout                                              CAP191
                                                                                              CAP191
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
      ** Current Deal in File Format of main deal
     D FUNDFilFmt1   E DS                  EXTNAME(MMDELDPP)
     D                                     Prefix(D1:2)
     D  Q1DORI       E                     EXTFLD(QQDORI)                                     CGL029
     D  Q1MORI       E                     EXTFLD(QQMORI)                                     CGL029
     D  Q1DOPI       E                     EXTFLD(QQDOPI)                                     CGL029
     D  Q1MOPI       E                     EXTFLD(QQMOPI)                                     CGL029
     D  Q1RONS       E                     EXTFLD(QQRONS)                                     CGL029
     D  Q1PONS       E                     EXTFLD(QQPONS)                                     CGL029
     D  Q1INSA       E                     EXTFLD(QQINSA)                                     CGL029
 
      ** Current Deal in File Format of associated deal
     D FUNDFilFmt2   E DS                  EXTNAME(MMDELDPP)
     D                                     Prefix(D2:2)
     D  Q2DORI       E                     EXTFLD(QQDORI)                                     CGL029
     D  Q2MORI       E                     EXTFLD(QQMORI)                                     CGL029
     D  Q2DOPI       E                     EXTFLD(QQDOPI)                                     CGL029
     D  Q2MOPI       E                     EXTFLD(QQMOPI)                                     CGL029
     D  Q2RONS       E                     EXTFLD(QQRONS)                                     CGL029
     D  Q2PONS       E                     EXTFLD(QQPONS)                                     CGL029
     D  Q2INSA       E                     EXTFLD(QQINSA)                                     CGL029
 
      **-----------------------------------------------------------------------
 
      ** Data structure for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10A
     D  PDBRN                 11     13A
     D  PDPPT                 14     16A
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
     D PSard           S              6A
     D CAS004          S              1A
     D CDL019          S              1A                                                      CDL019
     D CDL020          S              1A                                                      CDL020
     D @TimeStamp      S             26A                                                      CAP191
     D AAuth           S              1A                                                      CAP191
 
      **-----------------------------------------------------------------------
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDDLNO_IN         6
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'ABUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'MEMSG'
 
      * Hook to enable non-core message files to be included
     D/COPY WNCPYSRC,ABFUNDM01
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn                              ************
     C                   EVAL      DBFILE =  'SDBANKPD'                         * DBERR 01 *
     C                   EVAL      DBASE  =  001                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access General Ledger Details
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Database Error
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn                              ************
     C                   EVAL      DBFILE =  'SDGELRPD'                         * DBERR 02 *
     C                   EVAL      DBASE  =  002                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Dealing Data Details
 
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn                              ************
     C                   EVAL      DBFILE =  'SDDEALPD'                         * DBERR 03 *
     C                   EVAL      DBASE  =  003                                ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CAS004 is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*VERIFY'     @Optn
     C                   PARM      'CAS004'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RtCd = *Blanks
     C                   EVAL      CAS004 = 'Y'
     C                   ELSE
     C                   EVAL      CAS004 = 'N'
     C                   ENDIF
                                                                                              CDL019
      ** Check if CDL019 is installed                                                         CDL019
                                                                                              CDL019
     C                   CALLB     'AOSARDR0'                                                 CDL019
     C                   PARM      *BLANKS       @RtCd                                        CDL019
     C                   PARM      '*VERIFY'     @Optn                                        CDL019
     C                   PARM      'CDL019'      PSard                                        CDL019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL019
                                                                                              CDL019
     C                   IF        @RtCd = *Blanks                                            CDL019
     C                   EVAL      CDL019 = 'Y'                                               CDL019
     C                   ELSE                                                                 CDL019
     C                   EVAL      CDL019 = 'N'                                               CDL019
     C                   ENDIF                                                                CDL019
                                                                                              CDL020
      ** Check if CDL020 is installed                                                         CDL020
                                                                                              CDL020
     C                   CALLB     'AOSARDR0'                                                 CDL020
     C                   PARM      *BLANKS       @RtCd                                        CDL020
     C                   PARM      '*VERIFY'     @Optn                                        CDL020
     C                   PARM      'CDL020'      PSard                                        CDL020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL020
                                                                                              CDL020
     C                   IF        @RtCd = *Blanks                                            CDL020
     C                   EVAL      CDL020 = 'Y'                                               CDL020
     C                   ELSE                                                                 CDL020
     C                   EVAL      CDL020 = 'N'                                               CDL020
     C                   ENDIF                                                                CDL020
 
      ** Retrieve ZMUSER details
 
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
 
      * Set action code to enquire, unless authorising
     C                   CLEAR                   FUNDFilFmt1
     C                   CLEAR                   FUNDFilFmt2
 
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
 
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF
 
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      ABFUNDRED
     C                   ELSE
     C                   MOVEL     DDDLNO_IN     @DLNO             6
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If Internal Funding Deals read and no error message returned
     C                   IF        ReturnCode = *BLANK and
     C                             @DLNO <> *Blank
      *
      * Retrieve deal details (all key fields required for call to rtv module)
     C                   MOVEL     @DLNO         DDDLNO
     C                   EXSR      ABFUNDRTV
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      ABFUNDCVT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        @ERRMS <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDDLNO'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
     C                   MOVEL     D1TMST        @TimeStamp                                   CAP191
     C**********         EVAL      Buffer = FUNDScnFmt + PDDSTS                               CAP191
     C                   EVAL      Buffer = FUNDScnFmt + PDDSTS + @TimeStamp +                CAP191
     C**********                   ExtData + AAuth                                     CAP191 261140
     C                             ExtData + AAuth + FRNT + AFRT                              261140
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     ABFUNDRED     BEGSR
      *
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'ABFUNDRED'
 
      ** Input Parameters
      ** ================
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
 
     C                   PARM      '      '      PModeOfOp         6
 
      ** Deal Number Pointer
      ** Front Office ID
 
     C                   PARM                    DDDLNO            6
     C                   PARM                    PFrntId          20
 
      ** Read Forwards
      ** Read Backwards
 
     C                   PARM                    @RDFWD            1
     C                   PARM                    @RDBCK            1
 
      ** Standing Data
      ** =============
      ** SDBANKPD
      ** ========
 
     C                   PARM                    BJSBRC
 
      ** Output Parameters
      ** =================
      ** Error Message
      ** Deal Number Read
      ** Front Office ID READ
 
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        PRdDeal           6
     C                   PARM      *BLANK        PRdFrntID        20
 
     C                   ENDSR
      **********************************************************************
     C     ABFUNDRTV     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'ABFUNDRTV'
 
      ** Input Parameters
      ** ================
      * Return code
 
     C                   PARM                    RetCodeOut
 
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
 
     C                   PARM      '*SIN  '      PModeOfOp
 
      ** Response mode
 
     C                   PARM      'S'           PRespMode         1
 
      ** Action Code
      ** Front Office Transaction ID
      ** Front Office Associated Transaction Id
      ** (Midas) Deal Number
      ** (Midas) Associated Deal Number
      ** (Midas) Booking Branch
      ** (Midas) Booking Branch for Associated Deal
      ** Linked maintenance flag
 
     C                   PARM                    DDACTN            1
     C                   PARM                    PFrntId
     C                   PARM                    PFrntAsId        20
     C                   PARM                    DDDLNO
     C                   PARM                    DDDADN            6
     C                   PARM                    DDBRC1            3
     C                   PARM                    DDBRC2            3
     C                   PARM                    PLnkFlag          1
 
      ** Standing Data
      ** =============
      ** SDBANKPD
      ** ========
 
     C                   PARM                    BJSBRC
 
      ** SDGELRPD
      ** ========
 
     C                   PARM                    BKOBUV
 
      ** ZMUSER
      ** ========
 
     C                   PARM                    PDBRN
 
      ** Output Parameters
      ** =================
      ** (Current) deal in file format of deal
      ** (Current) deal in file format of deal of associated deal
      ** OK - Action code
      ** OK - Deal Number
      ** OK - Booking branch
      ** OK - Booking branch for associated deal number
 
     C                   PARM                    FUNDFilFmt1
     C                   PARM                    FUNDFilFmt2
     C                   PARM      *BLANK        OKACTN            1
     C                   PARM      *BLANK        OKDLNO            1
     C                   PARM      *BLANK        OKBRC1            1
     C                   PARM      *BLANK        OKBRC2            1
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM      *ZERO         Idx
 
     C                   ENDSR
      **********************************************************************
     C     ABFUNDCVT     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'ABFUNDCVT'
 
      ** Input Parameter
      ** ================
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Action Code
 
     C                   PARM                    DDACTN
 
      ** Deal in file format of deal
      ** Deal in file format of associated deal
 
     C                   PARM                    FUNDFilFmt1
     C                   PARM                    FUNDFilFmt2
 
      ** Standing Data
      ** =============
      ** SDBANKPD
      ** ========
 
     C                   PARM                    BJDFIN
 
      ** SDDEALPD
      ** ========
 
     C                   PARM                    BNDCSP
 
     C                   PARM                    CAS004
 
     C                   PARM                    CDL019                                       CDL019
                                                                                              CDL019
     C                   PARM                    CDL020                                       CDL020
                                                                                              CDL020
      ** Output Parameters
      ** =================
      ** Deal in screen format
 
     C                   PARM                    FUNDScnFmt
 
      ** Deal Status
 
     C                   PARM                    PDDSTS            7
 
      ** Profit Centre Description 1
      ** Profit Centre Description 2
 
     C                   PARM                    PPRF1D           30
     C                   PARM                    PPRF2D           30
 
      ** Front Office Transaction ID                                                          261140
      ** Associated Front Office Transaction ID                                               261140
     C                   PARM                    FRNT             20                          261140
     C                   PARM                    AFRT             20                          261140
                                                                                              261140
     C                   ENDSR
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      **********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      **********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
