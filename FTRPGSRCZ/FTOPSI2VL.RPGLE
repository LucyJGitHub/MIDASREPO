     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing Payments SSI Screen 2 Validation')   *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPSI2VL - Outgoing Payments SSI Secondary Detail           *
      *              Screen Validation                                *
      *                                                               *
      *  Function:  Secondary screen validation for Outgoing          *
      *             Payments Standard Settlement Instructions         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CFT162             Date 08Sep17               *
      *  Prev Amend No. CFT157             Date 29Aug14               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 BUG14716           Date 24Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 30Oct03               *
      *                 CGP001             Date 16Oct03               *
      *                 CFT018  *CREATE    Date 29Nov02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CFT162 - MT900 and MT910 Message Generation (Recompile)      *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  BUG14716 - CFT032 pre-req missing CFT018 OPSI Outgoing       *
      *             Payments Template                                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Correct parameters on program calls                 *
      *  CGP001 - Global Processing.                                  *
      *         - Recompile due to change in FTVOPY2PD.               *
      *  CFT018 - Standard Settlement Instructions for                *
      *           Outgoing Payments                                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ********************************************************************
      *  +--------------------------------------+
      *  ¦ Automatically included D-specs       ¦
      *  ¦ ==============================       ¦
      *  +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      *
      *
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      *
     D #I              S              2  0
      *
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
      *
      ** Program message queue
     D WPrgQ           S             10A
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D SSIFileFmt    E DS                  EXTNAME(FTOSSIPD)
      * Current Outgoing Payment SSI in File Format
      *
     D SSIScrnFmt    E DS                  EXTNAME(FTOPSIPD)
      * Current Outgoing Payment SSI in Screen Format
      *
     D SSIValidFmt   E DS                  EXTNAME(FTVOPSIPD)
     D  QQDRA1       E                     EXTFLD(QQDRAC)                                     CGL029
     D  QQORB1       E                     EXTFLD(QQORBK)                                     CGL029
     D  QQCDR1       E                     EXTFLD(QQCDRO)                                     CGL029
      * New Outgoing Payment SSI in File Format
      *
     D WorkFields    E DS                  EXTNAME(FTV@OPSIPD)
      * Common Work Fields
      *
     D FTEOPSI       E DS                  EXTNAME(FTEOPSIPD)
      * Error indicators
      *
     D FldNamXAr       S             10A   DIM(XArrayMax)
      * Array of Fields in error.
      *
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
      * Array of error message IDs
      *
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      ** Array of error message data.
      *
     D WFldNmXAr       S             10A   DIM(XArrayMax)
      ** Array of Fields with warnings.
      *
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
      ** Array of warning message IDs
      *
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      ** Array of warning message data.
      *
      * Outgoing Payment Screen Formats
     D OPAYDtls1     E DS                  EXTNAME(FTOPY1PD)
     D                                     PREFIX(S)
     D OPAYDtls1x    E DS                  EXTNAME(FTOPY1APD)
     D                                     PREFIX(S)
     D OPAYDtls2     E DS                  EXTNAME(FTOPY2PD)
     D                                     PREFIX(S)
     D OPAYDtls3     E DS                  EXTNAME(FTOPY3PD)
     D                                     PREFIX(S)
     D OPAYDtls4     E DS                  EXTNAME(FTOPY4PD)
     D                                     PREFIX(S)
     D OPAYDtls5     E DS                  EXTNAME(FTOPY5PD)
     D                                     PREFIX(S)
     D OPAYDtls6     E DS                  EXTNAME(FTOPY6PD)
     D                                     PREFIX(S)
      *
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY2PD)
     D                                     PREFIX(S)
      * Flags to indicate whether transaction fields are valid
      *
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
     D                                     PREFIX(@)
      * Validation Work Fields
      *
     D ExtData       E DS                  EXTNAME(FTOPEXPD)
     D                                     PREFIX(X)
      * FT (OPAY) Extra Data - File (D/B) format
      *
     D NwPtFilFmt    E DS                  EXTNAME(FTVOPAYPD)
     D  QQORB2       E                     EXTFLD(QQORBK)                                     CGL029
     D  QQCDR2       E                     EXTFLD(QQCDRO)                                     CGL029
      * New Payment in File Format
      *
     D NwPtFilFmx    E DS                  EXTNAME(FTVOPY2PD)
      ** New Payment in File Format (Extension)
      *
     D DEFVALIDX     E DS                  EXTNAME(FTVOPY2PD)
     D                                     PREFIX(D#)
      ** Valid Outgoing Payments Extension File (default)
      *
     D DEFVALID      E DS                  EXTNAME(FTVOPAYPD)
     D                                     PREFIX(D#)
      * Valid Payments layout (default)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      * Third DS for access programs, Very long data structure
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer details layout
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * External DS for Bank details
      *
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      * External DS for Funds Transfer details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT120
      *                                                                                       CFT120
      ** Switchable Features File                                                             CFT120
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D CFT120          S              1A                                                      CFT120
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      **********************************************************************
      /EJECT
      **********************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      **  Initialisation
     C                   Exsr      INIT
      *
      **  Validate secondary screen details
     C                   Exsr      ValScrn
      *
      **  Set error flags
     C                   Exsr      SetFlags
      *
      **  Set fields on valid file layout if no errors
     C     Idx           Ifeq      *Zero
     C                   Exsr      SetValFlds
     C                   Endif
      *
      **  Return to calling program
     C                   Return
      *
      /EJECT
      **********************************************************************
      * INIT - Initialisation Processing each time module is invoked
      **********************************************************************
     C     INIT          Begsr
      *
      **  Reset all fields in data structure layouts
     C                   Clear                   OPAYDtls1
     C                   Clear                   OPAYDtls1x
     C                   Clear                   OPAYDtls2
     C                   Clear                   OPAYDtls3
     C                   Clear                   OPAYDtls4
     C                   Clear                   NwPtFilFmt
     C                   Clear                   NwPtFilFmX
      *
      **  Move detail screen 1 fields to layout of FTOPY1PD
     C                   Move      SACTION       SSACTION
     C                   Move      SDRCY         SSSMCY
     C                   Move      SCRCY         SSPCCY
     C                   Move      SBRCA         SSBRCA
     C                   Move      SORBR         SSORBR
     C                   Move      SPYTP         SSPYTP
     C                   Move      SPYST         SSPYST
     C                   Move      SSTMT         SSSTTP
     C                   Move      SSWPC         SSSWPC
     C                   Move      SDST1         SSDST1
     C                   Move      SDST2         SSDST2
     C                   Move      SDST3         SSDST3
     C                   Move      SDST4         SSDST4
     C                   Move      SODMT         SSODMT
     C                   Move      SORC1         SSORC1
     C                   Move      SORC2         SSORC2
     C                   Move      SORC3         SSORC3
     C                   Move      SORC4         SSORC4
     C                   Move      SORC5         SSORC5                                     BUG14716
     C                   Move      SORBK         SSORBK
     C                   Move      SORBB         SSORBB
     C                   Move      SSNCO         SSSNCO
     C                   Move      SSNMT         SSSNMT
     C                   Move      SADDC         SSADDC
     C                   Move      SBOKC         SSBOKC
     C                   Move      SPRFC         SSPRFC
     C                   Move      SOFCD         SSOFCD
      *
      **  Move detail screen 2 fields to layout of FTOPY2PD
     C                   Move      SBOCD         SSBOCD
     C                   Move      STTCD         SSTRTC
     C                   Move      SRCO1         SSRCO1
     C                   Move      SRCO2         SSRCO2
     C                   Move      SRCO3         SSRCO3
     C                   Move      SRCO4         SSRCO4
     C                   Move      SRCO5         SSRCO5
     C                   Move      STRI1         SSTRI1
     C                   Move      STRI2         SSTRI2
     C                   Move      STRI3         SSTRI3
     C                   Move      STRI4         SSTRI4
     C                   Move      STRI5         SSTRI5
     C                   Move      SINB1         SSINB1
     C                   Move      SINB2         SSINB2
     C                   Move      SINB3         SSINB3
     C                   Move      SINB4         SSINB4
      *
      **  Move detail screen 2 fields to layout of FTOPY3PD
     C                   Move      SINB5         SSINB5
     C                   Move      SACB1         SSACB1
     C                   Move      SACB2         SSACB2
     C                   Move      SACB3         SSACB3
     C                   Move      SACB4         SSACB4
     C                   Move      SACB5         SSACB5
     C                   Move      SBNC1         SSBNC1
     C                   Move      SBNC2         SSBNC2
     C                   Move      SBNC3         SSBNC3
     C                   Move      SBNC4         SSBNC4
     C                   Move      SBNC5         SSBNC5
      *
      **  Move detail screen 3 fields to layout of FTOPY4PD
     C                   Move      SDTP1         SSDTP1
     C                   Move      SDTP2         SSDTP2
     C                   Move      SDTP3         SSDTP3
     C                   Move      SDTP4         SSDTP4
     C                   Move      SBBI1         SSBBI1
     C                   Move      SBBI2         SSBBI2
     C                   Move      SBBI3         SSBBI3
     C                   Move      SBBI4         SSBBI4
     C                   Move      SBBI5         SSBBI5
     C                   Move      SBBI6         SSBBI6
     C                   Move      SDNBC         SSDNBC
     C                   Move      SCHAP         SSCHAP
     C                   Move      STRCT         SSTRCT
     C                   Movel     SICD1         SSICD1
     C                   Movel     SICD2         SSICD2
     C                   Movel     SICD3         SSICD3
      *
      **  Move detail screen 3 fields to layout of FTOPY5PD
     C                   Movel     SICD4         SSICD4
     C                   Movel     SICD5         SSICD5
     C                   Movel     SRRP1         SSRRP1
     C                   Movel     SRRP2         SSRRP2
     C                   Movel     SRRP3         SSRRP3
      *
      **  Move detail screen 3 fields to layout of FTOPY6PD
     C                   Move      SCDRO         SSCDRO
     C                   Move      SCDBR         SSCDBR
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   Move      SCDRC         SSCDRC                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   Move      SDTCH         SSDTCH
      *
      ** Reset all error flags on layout of FTEOPY2PD
     C                   Move      *All'Y'       OkFlagsDS
      *
     C                   Endsr
      /EJECT
      **********************************************************************
      * ValScrn - Validate Secondary Detail Screen
      **********************************************************************
     C     ValScrn       Begsr
      *
     C                   Callb     'FTOPAY2VL'
      * Response mode
     C                   Parm                    @RespMode
      ** Payment Details
     C                   Parm                    OPAYDtls1
     C                   Parm                    OPAYDtls2
     C                   Parm                    OPAYDtls3
     C                   Parm                    OPAYDtls1x
     C                   Parm                    OPAYDtls4
      * Custom Extra Data file data
     C                   Parm                    ExtData
      ** Payment Primary Details OK inds
     C                   Parm                    OKFlagsDs
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx
      * Valid Payment layout (DS) from/to caller
     C                   Parm                    NwPtFilFmt
     C                   Parm                    NwPtFilFmX
      *  Validation Work Fields from/to caller
     C                   Parm                    Val@Fields
      ***Saved*default*charges***************************************                         222373
     C*****              Parm                    DEFVALID                                     222373
     C*****              Parm                    DEFVALIDX                                    222373
      *
     C                   Endsr
      /EJECT
      **********************************************************************
      * SetFlags - Set error flags for return to calling program
      **********************************************************************
     C     SetFlags      Begsr
      *
      **  Set error flags on data structure layout of FTEOPSIPD
     C                   Move      SOKBOCD       OKBOCD
     C                   Move      SOKTRTC       OKTTCD
     C                   Move      SOKRCO1       OKRCO1
     C                   Move      SOKRCO2       OKRCO2
     C                   Move      SOKRCO3       OKRCO3
     C                   Move      SOKRCO4       OKRCO4
     C                   Move      SOKRCO5       OKRCO5
     C                   Move      SOKTRI1       OKTRI1
     C                   Move      SOKTRI2       OKTRI2
     C                   Move      SOKTRI3       OKTRI3
     C                   Move      SOKTRI4       OKTRI4
     C                   Move      SOKTRI5       OKTRI5
     C                   Move      SOKINB1       OKINB1
     C                   Move      SOKINB2       OKINB2
     C                   Move      SOKINB3       OKINB3
     C                   Move      SOKINB4       OKINB4
     C                   Move      SOKINB5       OKINB5
     C                   Move      SOKACB1       OKACB1
     C                   Move      SOKACB2       OKACB2
     C                   Move      SOKACB3       OKACB3
     C                   Move      SOKACB4       OKACB4
     C                   Move      SOKACB5       OKACB5
     C                   Move      SOKBNC1       OKBNC1
     C                   Move      SOKBNC2       OKBNC2
     C                   Move      SOKBNC3       OKBNC3
     C                   Move      SOKBNC4       OKBNC4
     C                   Move      SOKBNC5       OKBNC5
      *
     C                   Endsr
      /EJECT
      **********************************************************************
      * SetValFlds - Set Fields on Valid File Layout
      **********************************************************************
     C     SetValFlds    Begsr
      *
      **  Bank Operation Code
     C                   Move      SBOCD         OVBOCD
      *
      **  Transaction type code
     C                   Move      STTCD         OVTTCD
      *
      **  Receivers Correspondent
     C                   Move      @@RCRT        OVRCRT
     C                   Move      SRCO1         OVRCO1
     C                   Move      SRCO2         OVRCO2
     C                   Move      SRCO3         OVRCO3
     C                   Move      SRCO4         OVRCO4
     C                   Move      SRCO5         OVRCO5
      *
      ** Third Reimbursement Institution
     C                   Move      @@TRIT        OVTRIT
     C                   Move      STRI1         OVTRI1
     C                   Move      STRI2         OVTRI2
     C                   Move      STRI3         OVTRI3
     C                   Move      STRI4         OVTRI4
     C                   Move      STRI5         OVTRI5
      *
      **  Intermediary Bank
     C                   Move      @@INBT        OVINBT
     C                   Move      SINB1         OVINB1
     C                   Move      SINB2         OVINB2
     C                   Move      SINB3         OVINB3
     C                   Move      SINB4         OVINB4
     C                   Move      SINB5         OVINB5
      *
      **  Account with Bank
     C                   Move      @@ACBT        OVACBT
     C                   Move      SACB1         OVACB1
     C                   Move      SACB2         OVACB2
     C                   Move      SACB3         OVACB3
     C                   Move      SACB4         OVACB4
     C                   Move      SACB5         OVACB5
      *
      **  Beneficiary
     C                   Move      @@BNCT        OVBNCT
     C                   Move      SBNC1         OVBNC1
     C                   Move      SBNC2         OVBNC2
     C                   Move      SBNC3         OVBNC3
     C                   Move      SBNC4         OVBNC4
     C                   Move      SBNC5         OVBNC5
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     Begsr
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   Eval      RetCodeOut = *Blanks
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
     C                   Eval      WFldNmXAr = *BlankS
     C                   Eval      WMsgIDXAr = *BlankS
     C                   Eval      WMsgDtXAr  = *BlankS
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
     C     UPDATERRS     Begsr
      *
      * Update error fields/message IDs/message data (arrays)
     C                   Eval      #I = 1
     C     *Blank        Lookup    FldNameArr(#I)                         99
     C                   If        *IN99 = *On
     C                   Movea     FldNamXar     FldNameArr(#I)
     C                   Movea     MsgIDXAr      MsgIdArr(#I)
     C                   Movea     MsgDtaXAr     MsgDtaArr(#I)
     C                   End
      *
      * Set Error Index
     C                   Eval      #I = 1
     C     *Blank        Lookup    FldNameArr(#I)                         99
     C                   Eval      Idx = #I - 1
      *
      * Update warning fields/message IDs/message data (arrays)
     C                   Eval      #I = 1
     C     *Blank        Lookup    WFldNamArr(#I)                         99
     C                   If        *IN99 = *On
     C                   Movea     WFldNmXAr     WFldNamArr(#I)
     C                   Movea     WMsgIDXAr     WMsgIDArr(#I)
     C                   Movea     WMsgDtXAr     WMsgDtaArr(#I)
     C                   End
      *
      * Set Warning Index
     C                   Eval      #I = 1
     C     *Blank        Lookup    WFldNamArr(#I)                         99
     C                   Eval      WIdx = #I - 1
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * InitWrkFld - Initialise work fields passed to validation modules
      *****************************************************************
     C     InitWrkFld    Begsr
      *
      **  Clear data structure work fields passed to FTOPAY3VL
     C                   Clear                   Val@Fields
      *
      **  Pass switchable feature indicators
     C                   Move      @01494        @@01494
     C                   Move      @01499        @@01499
     C                   Move      @01506        @@01506
     C                   Move      @01508        @@01508
     C                   Move      @CEU006       @@CEU006
     C                   Move      @CFT003       @@CFT003
     C                   Move      @CFT004       @@CFT004
     C                   Move      @CFT007       @@CFT007
     C                   Move      @CFT009       @@CFT009
     C                   Move      @CFT010       @@CFT010
     C                   Move      @CFT014       @@CFT014
     C                   Move      @CSC011       @@CSC011
     C                   Move      @MBIN         @@MBIN
     C                   Move      @DFBR         @@DFBR
     C                   Move      @DPPT         @@DPPT
     C                   Move      @USRID        @@USRID
     C                   Move      @BCDP         @@BCDP
     C                   Move      @BVLD         @@BVLD
     C                   Move      @RUNN         @@RUNN
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        Begsr
      *
      ** Program entry parameter list
     C     *Entry        Plist
      *    Return code
     C                   Parm      *Blank        RetCodeOut
      *    Transaction screen fields
     C                   Parm                    SSIScrnFmt
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
      *    Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx
      *    Error flag indicators
     C                   Parm                    FTEOPSI
      *    Valid file layout
     C                   Parm                    SSIValidFmt
      *
      ** Initialise program name
     C                   Movel     'FTOPSI2VL'   DBPGM
      *
      ** Initialise work fields to pass to validation modules
     C                   Exsr      InitWrkFld
      *
      ** Access bank details
     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C     SDBANK        Parm      SDBANK        DSFDY
      *
      ** Database error
     C     @RTCD         Ifne      *BLANKS
     C                   Move      'SDBANKPD'    DBFILE
     C                   Move      '901'         DBASE
     C                   Move      @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   Endif
      *                                                                                       CFT120
      ** Check if CFT120 is switched on                                                       CFT120
      *                                                                                       CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       @RTCD                                        CFT120
     C                   PARM      '*VERIFY'     @OPTN                                        CFT120
     C                   PARM      'CFT120'      @SARD             6                          CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   ELSE                                                                 CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD <> '*NRF '                                           CFT120
      *                                                                                       CFT120
     C                   EVAL      DBKEY = 'CFT120'                                           CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBASE = 001                                                CFT120
     C                   EXSR      *PSSR                                                      CFT120
      *                                                                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF                                                                CFT120
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
