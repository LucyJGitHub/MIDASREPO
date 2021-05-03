     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans amend checking 1')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIP1AD - Customer loans - Amend Checking for screen 1     *
      *                                                               *
      *  Function:  This module compares the fields of an             *
      *             amended loan against those currently on file.     *
      *             It checks whether all fields amended are          *
      *             amendable, and if not returns error messages to   *
      *             the calling process.                              *
      *             If can optionally reset fields wrongly amended.   *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 MD000091           Date 08May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 245273             Date 26Jan07               *
      *                 245411             Date 26Jan07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG9100            Date 21Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10671R          Date 07Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 CAP086             Date 08Jun05               *
      *                 CAP074  *CREATE    Date 10Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions (Recompile)                    *
      *  MD000091 - Event Codes Substitution                          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245273 - Recompiled due to changes in LECLI1PD.              *
      *  245411 - Recompiled due to changes in LECLI1PD.              *
      *  BUG9100 - For existing loans, validate recourse indicator    *
      *            properly.                                          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10671R - Auto generated error on completion of agented    *
      *              loan. (Recompile)                                *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements (Recompile)                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it. (Recompile)                             *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *
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
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
      *
     D LoanScnFm1    E DS                  EXTNAME(LECLI1PD)
      ***  (Current) Loan in Screen Format 1
     D                                     PREFIX(@)
      *
     D NewLoanScn1   E DS                  EXTNAME(LECLI1PD)
      ***  New Loan in Screen Format 1
      *
     D LnCLFilFmt    E DS                  EXTNAME(CLOANCL)
      ***  (Current) Loan CL in File Format
     D                                     PREFIX(CL_)
      *
     D LnCKFilFmt    E DS                  EXTNAME(CLOANCK)
      ***  (Current) Loan CK in File Format
     D                                     PREFIX(CK_)
      *
     D RUNDAT          DS
     D  @MBIN                 13     13
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, SHORT data structure
      *
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
      *
     D Idx             S              3P 0
      ***  Index for arrays of of error message ids etc
      *
     D OKLnScn1      E DS                  EXTNAME(LEECLI1PD)
      ***  Error indicators screen 1
      *
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      *                                                                                     MD000091
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
      *
      ***  Initialization.
      *
     C                   EXSR      INIT
      *
      ***  Compare fields with "amended" values or "changed" values.
      *
     C                   EXSR      COMPFLD
      *
      ***  If any errors were found:
      ***  Set Amendments OK Indicator to 'N'
      *
     C     Idx           IFGT      0
     C                   EVAL      AmendOK = 'N'
     C                   ELSE
     C                   EVAL      AmendOK = 'Y'
     C                   ENDIF
      *
      ***  If any errors were found
      ***  and reset of fields in error required, do this
      *
     C     Idx           IFGT      0
     C     ResetErrs     ANDEQ     'Y'
     C                   EXSR      RESETFLD
     C                   ENDIF
      *
      ***  Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      ********************************************************************
      * INIT - Initialization.                                           *
      ********************************************************************
     C     INIT          BEGSR
      *
      ***  Check type of processing
      *
     C                   MOVE      'N'           P_PTPU            1
     C                   MOVE      'N'           P_PTSO            1
     C                   SELECT
     C     LoanType      WHENEQ    'PTPU'
     C                   MOVE      'Y'           P_PTPU
     C     LoanType      WHENEQ    'PTSO'
     C                   MOVE      'Y'           P_PTSO
     C                   END
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      * COMPFLD  - Compare certain fields on the current customer     *
      *            loan with those "amended".                         *
      *****************************************************************
     C     COMPFLD       BEGSR
      *
      *-----------------------------------------*
      * Customer number                         *
      *-----------------------------------------*
      *
     C     DDCUST        IFNE      @DDCUST
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCUST'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0607'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDFCUS                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDFCUS))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDFCUS)                  MD000091
     C                   EVAL      DDCUSTok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Facility customer                       *
      *-----------------------------------------*
      *
     C     DDFCUS        IFNE      @DDFCUS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFCUS'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0608'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDFCUS                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDFCUS))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDFCUS)                  MD000091
     C                   EVAL      DDFCUSok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Facility type                           *
      *-----------------------------------------*
      *
     C     DDFTYP        IFNE      @DDFTYP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFTYP'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0609'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDFTYP                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDFTYP))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDFTYP)                  MD000091
     C                   EVAL      DDFTYPok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Facility sequence number                *
      *-----------------------------------------*
      *
     C     DDFSEQ        IFNE      @DDFSEQ
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFSEQ'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0610'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDFSEQ                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDFSEQ))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDFSEQ)                  MD000091
     C                   EVAL      DDFSEQok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Branch code                             *
      *-----------------------------------------*
      *
     C     DDBRCA        IFNE      @DDBRCA
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRCA'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0611'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDBRCA                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDBRCA))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDBRCA)                  MD000091
     C                   EVAL      DDBRCAok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Loan type                               *
      *-----------------------------------------*
      *
     C     DDLTYP        IFNE      @DDLTYP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLTYP'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0612'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDLTYP                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDLTYP))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDLTYP)                  MD000091
     C                   EVAL      DDLTYPok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Loan sub-type                           *
      *-----------------------------------------*
      *
     C     DDSUTP        IFNE      @DDSUTP
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSUTP'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0613'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDSUTP                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDSUTP))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDSUTP)                  MD000091
     C                   EVAL      DDSUTPok        = 'N'
     C                   END
      *                                                                                       CLE042
      *-----------------------------------------*                                             CLE042
      * Loan class                              *                                             CLE042
      *-----------------------------------------*                                             CLE042
      *                                                                                       CLE042
     C     DDCLAS        IFNE      @DDCLAS                                                    CLE042
     C                   ADD       1             Idx                                          CLE042
     C                   EVAL      FldNameArr(Idx) = 'DDCLAS'                                 CLE042
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0730'                                CLE042
     C**********         EVAL      MsgDtaArr(Idx)  = @DDCLAS                         CLE042 MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDCLAS))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDCLAS)                  MD000091
     C                   EVAL      DDCLASok        = 'N'                                      CLE042
     C                   END                                                                  CLE042
      *
      *-----------------------------------------*
      * Originating loan number                 *
      *-----------------------------------------*
      *
     C     DDOLNO        IFNE      @DDOLNO
     C     P_PTSO        ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDOLNO'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0614'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDOLNO                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDOLNO))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDOLNO)                  MD000091
     C                   EVAL      DDOLNOok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Purchased from                          *
      *-----------------------------------------*
      *
     C     P_PTPU        IFEQ      'Y'
     C                   CALLB     'ZCMPAMTS'
     C                   PARM      DDPFRM        ZCMPAMT1         25
     C                   PARM      @DDPFRM       ZCMPAMT2         25
     C                   PARM      'N'           ZCMPAMTDif        1
     C     ZCMPAMTDif    IFEQ      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPFRM'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0615'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDPFRM                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDPFRM))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDPFRM)                  MD000091
     C                   EVAL      DDPFRMok        = 'N'
     C                   END
     C                   END
      *
      *-----------------------------------------*
      * Mirror loan number                      *
      *-----------------------------------------*
      *
     C     DDMLNR        IFNE      @DDMLNR
     C     P_PTPU        ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMLNR'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0616'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDMLNR                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDMLNR))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDMLNR)                  MD000091
     C                   EVAL      DDMLNRok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Currency code                           *
      *-----------------------------------------*
      *
     C     DDCURR        IFNE      @DDCURR
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCURR'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0617'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDCURR                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDCURR))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDCURR)                  MD000091
     C                   EVAL      DDCURRok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Current principal amount                *
      *-----------------------------------------*
      *
     C                   CALLB     'ZCMPAMTS'
     C                   PARM      DDCPAM        ZCMPAMT1         25
     C                   PARM      @DDCPAM       ZCMPAMT2         25
     C                   PARM      'N'           ZCMPAMTDif        1
 
     C     ZCMPAMTDif    IFEQ      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCPAM'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0618'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDCPAM                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDCPAM))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDCPAM)                  MD000091
     C                   EVAL      DDCPAMok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Deal date                               *
      *-----------------------------------------*
      *
     C     DDDDAT        IFNE      @DDDDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0619'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDDDAT                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDDDAT))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDDDAT)                  MD000091
     C                   EVAL      DDDDATok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Value date                              *
      *-----------------------------------------*
      *
     C     DDVDAT        IFNE      @DDVDAT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0620'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDVDAT                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDVDAT))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDVDAT)                  MD000091
     C                   EVAL      DDVDATok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Recourse indicator                      *
      *-----------------------------------------*
      *
     C                   IF        @DDRCSI <> 'Y'                                            BUG9100
     C                   EVAL      @DDRCSI = 'N'                                             BUG9100
     C                   ENDIF                                                               BUG9100
      *                                                                                      BUG9100
     C                   IF        CL_ORED < BJRDNB                                          BUG9100
     C     DDRCSI        IFNE      @DDRCSI
     C     P_PTSO        ANDEQ     'Y'
     C     DDRCSI        ORNE      @DDRCSI
     C     P_PTPU        ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRCSI'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0621'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDRCSI                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDRCSI))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDRCSI)                  MD000091
     C                   EVAL      DDRCSIok        = 'N'
     C                   END
     C                   END                                                                 BUG9100
      *
      *-----------------------------------------*
      * Auto payment at maturity                *
      *-----------------------------------------*
      *
     C     DDAPMI        IFNE      @DDAPMI
     C     S01465        ANDEQ     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAPMI'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0649'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDAPMI                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDAPMI))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDAPMI)                  MD000091
     C                   EVAL      DDAPMIok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Rollover date                           *
      *-----------------------------------------*
      *
     C     DDRLDT        IFNE      @DDRLDT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDT'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0622'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDRLDT                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDRLDT))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDRLDT)                  MD000091
     C                   EVAL      DDRLDTok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Rollover frequence                      *
      *-----------------------------------------*
      *
     C     DDRLFQ        IFNE      @DDRLFQ
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLFQ'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0623'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDRLFQ                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDRLFQ))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDRLFQ)                  MD000091
     C                   EVAL      DDRLFQok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Rollover day                            *
      *-----------------------------------------*
      *
     C     DDRLDY        IFNE      @DDRLDY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDY'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0624'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDRLDY                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDRLDY))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDRLDY)                  MD000091
     C                   EVAL      DDRLDYok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Rollover rate fixing days               *
      *-----------------------------------------*
      *
     C     DDRFDY        IFNE      @DDRFDY
     C     CLE011        ANDEQ     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRFDY'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0628'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDRFDY                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDRFDY))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDRFDY)                  MD000091
     C                   EVAL      DDRFDYok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Default part. loan type                 *
      *-----------------------------------------*
      *
     C     DDDFTP        IFNE      @DDDFTP
     C     CLE006        ANDEQ     'N'
     C     P_PTSO        ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDFTP'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0629'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDDFTP                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDDFTP))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDDFTP)                  MD000091
     C                   EVAL      DDDFTPok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Default part. loan sub-type             *
      *-----------------------------------------*
      *
     C     DDDFST        IFNE      @DDDFST
     C     CLE006        ANDEQ     'N'
     C     P_PTSO        ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDFST'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0630'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDDFST                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDDFST))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDDFST)                  MD000091
     C                   EVAL      DDDFSTok        = 'N'
     C                   END
      *-----------------------------------------*                                             CLE042
      * Default part. loan class                *                                             CLE042
      *-----------------------------------------*                                             CLE042
      *                                                                                       CLE042
     C     DDDFCL        IFNE      @DDDFCL                                                    CLE042
     C     CLE006        ANDEQ     'N'                                                        CLE042
     C     P_PTSO        ANDEQ     'Y'                                                        CLE042
     C                   ADD       1             Idx                                          CLE042
     C                   EVAL      FldNameArr(Idx) = 'DDDFCL'                                 CLE042
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0731'                                CLE042
     C**********         EVAL      MsgDtaArr(Idx)  = @DDDFCL                         CLE042 MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDDFCL))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDDFCL)                  MD000091
     C                   EVAL      DDDFCLok        = 'N'                                      CLE042
     C                   END                                                                  CLE042
      *
      *-----------------------------------------*
      * Linked to syndicate                     *
      *-----------------------------------------*
      *
     C     DDLNKS        IFNE      @DDLNKS
     C     CLE006        ANDEQ     'N'
     C     P_PTPU        ANDEQ     'N'
     C     P_PTSO        ANDEQ     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLNKS'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0631'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDLNKS                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDLNKS))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDLNKS)                  MD000091
     C                   EVAL      DDLNKSok        = 'N'
     C                   END
      *
      *-----------------------------------------*
      * Assignment / participant                *
      *-----------------------------------------*
      *
     C     DDASSN        IFNE      @DDASSN
     C     CLE006        ANDEQ     'N'
     C     P_PTPU        ANDEQ     'N'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDASSN'
     C                   EVAL      MsgIDArr(Idx)   = 'LEL0632'
     C**********         EVAL      MsgDtaArr(Idx)  = @DDASSN                                MD000091
     C                   EVAL      BLen = %Len(%Trim(@DDASSN))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(@DDASSN)                  MD000091
     C                   EVAL      DDASSNok        = 'N'
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETFLD - Reset fields in Error                              *
      *****************************************************************
     C     RESETFLD      BEGSR
      *
      ***  Reset fields in error to 'current' values
      *    =========================================
      *
      ***  Loan number
      *
     C     DDLNRFok      IFEQ      'N'
     C                   MOVEL     @DDLNRF       DDLNRF
     C                   END
      *
      *-----------------------------------------*
      * Customer number                         *
      *-----------------------------------------*
      *
     C     DDCUSTok      IFEQ      'N'
     C                   MOVEL     @DDCUST       DDCUST
     C                   END
      *
      *-----------------------------------------*
      * Facility customer                       *
      *-----------------------------------------*
      *
     C     DDFCUSok      IFEQ      'N'
     C                   MOVEL     @DDFCUS       DDFCUS
     C                   END
      *
      *-----------------------------------------*
      * Facility type                           *
      *-----------------------------------------*
      *
     C     DDFTYPok      IFEQ      'N'
     C                   MOVEL     @DDFTYP       DDFTYP
     C                   END
      *
      *-----------------------------------------*
      * Facility sequence number                *
      *-----------------------------------------*
      *
     C     DDFSEQok      IFEQ      'N'
     C                   MOVEL     @DDFSEQ       DDFSEQ
     C                   END
      *
      *-----------------------------------------*
      * Branch code                             *
      *-----------------------------------------*
      *
     C     DDBRCAok      IFEQ      'N'
     C                   MOVEL     @DDBRCA       DDBRCA
     C                   END
      *
      *-----------------------------------------*
      * Loan type                               *
      *-----------------------------------------*
      *
     C     DDLTYPok      IFEQ      'N'
     C                   MOVEL     @DDLTYP       DDLTYP
     C                   END
      *
      *-----------------------------------------*
      * Loan sub-type                           *
      *-----------------------------------------*
      *
     C     DDSUTPok      IFEQ      'N'
     C                   MOVEL     @DDSUTP       DDSUTP
     C                   END
      *                                                                                       CLE042
      *-----------------------------------------*                                             CLE042
      * Loan class                              *                                             CLE042
      *-----------------------------------------*                                             CLE042
      *                                                                                       CLE042
     C     DDCLASok      IFEQ      'N'                                                        CLE042
     C                   MOVEL     @DDCLAS       DDCLAS                                       CLE042
     C                   END                                                                  CLE042
      *
      *-----------------------------------------*
      * Originating loan number                 *
      *-----------------------------------------*
      *
     C     DDOLNOok      IFEQ      'N'
     C                   MOVEL     @DDOLNO       DDOLNO
     C                   END
      *
      *-----------------------------------------*
      * Purchased from                          *
      *-----------------------------------------*
      *
     C     DDPFRMok      IFEQ      'N'
     C                   MOVEL     @DDPFRM       DDPFRM
     C                   END
      *
      *-----------------------------------------*
      * Mirror loan number                      *
      *-----------------------------------------*
      *
     C     DDMLNRok      IFEQ      'N'
     C                   MOVEL     @DDMLNR       DDMLNR
     C                   END
      *
      *-----------------------------------------*
      * Currency code                           *
      *-----------------------------------------*
      *
     C     DDCURRok      IFEQ      'N'
     C                   MOVEL     @DDCURR       DDCURR
     C                   END
      *
      *-----------------------------------------*
      * Current principal amount                *
      *-----------------------------------------*
      *
     C     DDCPAMok      IFEQ      'N'
     C                   MOVEL     @DDCPAM       DDCPAM
     C                   END
      *
      *-----------------------------------------*
      * Deal date                               *
      *-----------------------------------------*
      *
     C     DDDDATok      IFEQ      'N'
     C                   MOVEL     @DDDDAT       DDDDAT
     C                   END
      *
      *-----------------------------------------*
      * Value date                              *
      *-----------------------------------------*
      *
     C     DDVDATok      IFEQ      'N'
     C                   MOVEL     @DDVDAT       DDVDAT
     C                   END
      *
      *-----------------------------------------*
      * Recourse indicator                      *
      *-----------------------------------------*
      *
     C     DDRCSIok      IFEQ      'N'
     C                   MOVEL     @DDRCSI       DDRCSI
     C                   END
      *
      *-----------------------------------------*
      * Auto payment at maturity                *
      *-----------------------------------------*
      *
     C     DDAPMIok      IFEQ      'N'
     C                   MOVEL     @DDAPMI       DDAPMI
     C                   END
      *
      *-----------------------------------------*
      * Rollover date                           *
      *-----------------------------------------*
      *
     C     DDRLDTok      IFEQ      'N'
     C                   MOVEL     @DDRLDT       DDRLDT
     C                   END
      *
      *-----------------------------------------*
      * Rollover frequence                      *
      *-----------------------------------------*
      *
     C     DDRLFQok      IFEQ      'N'
     C                   MOVEL     @DDRLFQ       DDRLFQ
     C                   END
      *
      *-----------------------------------------*
      * Rollover day                            *
      *-----------------------------------------*
      *
     C     DDRLDYok      IFEQ      'N'
     C                   MOVEL     @DDRLDY       DDRLDY
     C                   END
      *
      *-----------------------------------------*
      * Rollover day                            *
      *-----------------------------------------*
      *
     C     DDRLDYok      IFEQ      'N'
     C                   MOVEL     @DDRLDY       DDRLDY
     C                   END
      *
      *-----------------------------------------*
      * Rollover rate fixing days               *
      *-----------------------------------------*
      *
     C     DDRFDYok      IFEQ      'N'
     C                   MOVEL     @DDRFDY       DDRFDY
     C                   END
      *
      *-----------------------------------------*
      * Default part. loan type                 *
      *-----------------------------------------*
      *
     C     DDDFTPok      IFEQ      'N'
     C                   MOVEL     @DDDFTP       DDDFTP
     C                   END
      *
      *-----------------------------------------*
      * Default part. loan sub-type             *
      *-----------------------------------------*
      *
     C     DDDFSTok      IFEQ      'N'
     C                   MOVEL     @DDDFST       DDDFST
     C                   END
      *                                                                                       CLE042
      *-----------------------------------------*                                             CLE042
      * Default part. loan class                *                                             CLE042
      *-----------------------------------------*                                             CLE042
      *                                                                                       CLE042
     C     DDDFCLok      IFEQ      'N'                                                        CLE042
     C                   MOVEL     @DDDFCL       DDDFCL                                       CLE042
     C                   END                                                                  CLE042
      *
      *-----------------------------------------*
      * Linked to syndicate                     *
      *-----------------------------------------*
      *
     C     DDLNKSok      IFEQ      'N'
     C                   MOVEL     @DDLNKS       DDLNKS
     C                   END
      *
      *-----------------------------------------*
      * Assignment / participant                *
      *-----------------------------------------*
      *
     C     DDASSNok      IFEQ      'N'
     C                   MOVEL     @DDASSN       DDASSN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ***  INPUTS
      *
      ***  Return Code
     C                   PARM                    RetCodeIn
      *
      ***  New Customer loan in Screen Format :
     C                   PARM                    NewLoanScn1
      *
      ***  (Current) Customer loan in Screen Format :
     C                   PARM                    LoanScnFm1
      *
      ***  Current Loan in file format
      *
     C                   PARM                    LnCLFilFmt
     C                   PARM                    LnCKFilFmt
      *
      ***  Calling type
     C                   PARM                    LoanType          4
      *
      ***  OUTPUTS
      *
      ***  Error Indicators
     C                   PARM                    OKLnScn1
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ***  Amendments OK
     C                   PARM                    AmendOk           1
      *
      ***  Reset of Fields in Error Required (Y/N)
     C                   PARM                    ResetErrs         1
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LECLIP1AD'   DBPGM
      *
      ***  Get rundat to access multi-branching flag.
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '001'         DBASE                          * DBERR 001 *
     C                   EXSR      *PSSR                                        *************
     C                   END
      *
      ** Determine if BLI Lending Enhancements feature is installed
      *
     C                   MOVEL     'N'           S01465            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01465'      @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           S01465
     C                   ELSE
     C     @RTCD         IFNE      '*NRF    '
     C     *LOCK         IN        LDA
     C                   MOVEL     'S01465'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   EXSR      *PSSR                                        *************
     C                   END
     C                   END
      *
      ***  Determine if Customer Lending Enhancements - Past Due Account
      ***  feature is installed
      *
     C                   MOVEL     'N'           CLE006            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE006'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CLE006
     C                   END
      *
      ***  Check if Rollover Rate Fixing Day Enhancement is switched on
      *
     C                   MOVEL     'N'           CLE011            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE011'      @SARD
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CLE011
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2002
