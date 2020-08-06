     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer Loans Extra validation for settl')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIPEVL -  Customer Loans Extra validations for settl.     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD055733           Date 03Jul20               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD045010           Date 05Apr17               *
      *                 MD039016           Date 26May16               *
      *                 CLE141A            Date 28Apr16               *
      *                 CLE141             Date 08Feb16               *
      *                 MD025521           Date 19Aug14               *
      *                 AR804863           Date 10Dec12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 AR702741           Date 02Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG21836           Date 20Feb09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 245273             Date 26Jan07               *
      *                 245411             Date 26Jan07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 BUG10671R          Date 07Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE031             Date 26Apr05               *
      *                 BUG5863            Date 14Feb04               *
      *                 BUG4351 (reopen)   Date 12Oct04               *
      *                 BUG4351            Date 23Sep04               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 224368             Date 14Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP074  *CREATE    Date 01Aug02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055733 - COB: Multiple UTCHOBJEX calls in LEC06A           *
      *             components.                                       *
      *           - Redeliver of MD050139.                            *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
      *  MD045010 - Component LEC06A 10008 looping during COB caused  *
      *             by CGL184. Recompile due to changes in ZFRQB3.    *
      *  MD039016 - Different event codes for BDC validation in       *
      *             various Lending APIs                              *
      *  CLE141A - CLE141 Change Control 1                            *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions                                *
      *  MD025521 - Recompile due to changes on LECLI2PD.             *
      *  AR804863 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Pass      *
      *             reject button to correctly revert back amended    *
      *             details. (Child: AR804864)                        *
      *           - Applied for AR910559 (Child: AR910560)            *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  BUG21836 - Wrong calculation of Next Repayment Date if       *
      *             falls on a holiday                                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  245273 - Recompiled due to changes in LECLI1PD.              *
      *  245411 - Recompiled due to changes in LECLI1PD.              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10671R - Auto generated error on completion of agented    *
      *              loan. (Recompile)                                *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  BUG5863 - Index of Warning errors array (WId) should be      *
      *            reset to zero to prevent array index out of range. *
      *  BUG4351 - Index of Warning errors array WFldNmXAr should be  *
      *            different to the index for WFldNamArr.             *
      *  BUG4351 - Remove the use of work fields to suppress warning  *
      *            errors being re-displayed when data unchanged.     *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028).   *
      *  224368 - VDAT validated after loan has started               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+
      *****************************************************************
      *

      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LECLIPEV01
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
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
      *
     D/COPY ZACPYSRC,PROCPARMS
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
     D XArrayMax       C                   CONST(40)
      ***  The maximum size of the appended error arrays

      *
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
      *
     D WNOST           S              2  0 DIM(5) CTDATA PERRCD(5)
      ** Settlements through nostros
      *
     D FldNamXAr       S             10A   DIM(XArrayMax)
      ***  Array of Fields in error.
      *
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
      ***  Array of error message IDs
      *
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      ***  Array of error message data.
      *
     D WFldNmXAr       S             10A   DIM(XArrayMax)
      ***  Array of Fields with warnings.
      *
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
      ***  Array of warning message IDs
      *
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      ***  Array of warning message data.
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ***  External DS for general ledger details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACCD1       E                     EXTFLD(QQACCD)                                     CGL029
      ***Nostro details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  First DS for access programs, long data structure
      *
     D NwLnScnFmt1   E DS                  EXTNAME(LECLI1PD)
      ***  New Loan in Screen Format - Screen 1
      *
     D NwLnScnFmt2   E DS                  EXTNAME(LECLI2PD)
      ***  New Loan in Screen Format - Screen 2
      *
     D NwLnScnFmt7   E DS                  EXTNAME(LECLI7PD)                                  CLE141
     D  CurLocPI              61    120                                                       CLE141
      ** New Loan in Screen Format - Business Day Conv                                        CLE141

     D OKFlag1DS     E DS                  EXTNAME(LEECLI1PD)
      ***  Flags to indicate whether transaction fields are valid
      *
     D OKFlag2DS     E DS                  EXTNAME(LEECLI2PD)
      ***  Flags to indicate whether transaction fields are valid
      *

     D Idx             S              3P 0
      ** Index for arrays of error message ids etc
      *
     D WId             S              3P 0
     D WIdx            S              3P 0                                                   BUG4351
      ***  Index for arrays of of warning message ids etc
      *

     D  TransData      DS           500
      ***  Shared data
      *
     D  WLNPT                  1      2  0
     D  W72TP                  3      4
     D  BASER                  5     15  7
     D  WSVBX                 16     28  8
     D  WBMIN                 29     29
     D  WSVDD                 30     34  0
     D  WSVVD                 35     39  0
     D  WSVAM                 40     52  0
     D  WSVRS                 53     63  7
     D  FCUSM                 64     69  0
     D  FTYPM                 70     72  0
     D  FSEQM                 73     74  0
     D  FCXRM                 75     87  8
     D  FMDIM                 88     88
     D  ORBRM                 89     91
     D  CRSKM                 92     93
     D  LINDM                 94     96
     D  PRFCM                 97    100
     D  ACOFM                101    102
     D  FCCYM                103    105
     D  FCLBM                106    108
     D  MCRAM                109    109
     D  PTYPM                110    111  0
     D  RLDTM                112    116  0
     D  NBRAM                117    118  0
     D  NCASM                119    119  0
     D  NCHIM                120    120
     D  NCCYM                121    123
     D  NFCEM                124    136  8
     D  NFMDM                137    137
     D  NBCEM                138    150  8
     D  NBMDM                151    151
     D  CNUMM                152    157
     D  BRCAM                158    160
     D  CCYM                 161    163
     D  CPAMM                164    176  0
     D  DDATM                177    181  0
     D  VDATM                182    186  0
     D  MDATM                187    191  0
     D  PSAMM                192    204  0
     D  WSVFX                205    217  8
     D  WFMIN                218    218
     D  FCCYF                219    221
     D  WLPFI                222    222
     D  WPASI                223    223
     D  WPTFC                224    229  0
     D  WPTFT                230    232  0
     D  WPTFN                233    234  0
     D  WACEI                235    235
     D  WCBLI                236    236
     D  WORMD                237    241  0
     D  WORTI                242    254  0
     D  WSVMG                255    261  5
     D  WSVWT                262    272  7
     D  WOSDB                273    275
     D  WOMDB                276    278
     D  W#OIDT               279    283  0
     D  WTOTI                284    296  0
     D  WPTFR                297    300
     D  WFSRP                301    311  7
     D  WSVFA                312    324  0
     D  NBDPM                325    325  0
     D  WSVCN                326    331
     D  WRISP                332    332
     D  NYET                 333    333
     D  WFLAG                334    334
     D  WCDPL                335    335  0
     D  WCDPF                336    336  0
     D  WSVTX                337    338  0
     D  WTXND                339    340  0
     D  S#ICBS               341    341  0
     D  WSVRAM               342    354  0
     D  WSVRAP               355    367  0
     D  W@FCRA               368    382
     D  W@RAMT               383    397
     D  W#CCY                398    400
     D  W#FCY                401    403
     D  WSVAM2               404    416  0
     D  WSVIN                417    417
     D  WSVRT                418    430  8
     D  W@NRPD               431    435  0
     D  ACOFF                436    437
     D  SYINF                438    438
     D  WAGENT               439    444
     D**ANUM****             445    450  0                                                    CSD027
     D**CNUMF***             451    456  0                                                    CSD027
     D**PMFC****             457    462  0                                                    CSD027
     D  ANUM                 445    450A                                                      CSD027
     D  CNUMF                451    456A                                                      CSD027
     D  PMFC                 457    462A                                                      CSD027
     D  W#SYCU               463    468
     D  WPTYP                469    470  0
     D  WLIND                471    473
     D  CRSKF                474    475
     D  WCHGA                476    488  0                                                   BUG3721
     D  WLCCD                489    491                                                      BUG3721
     D  WPRCS2               492    492                                                      BUG3721
      *
     D  DataOldRcd     DS           500
      ***  Fields used in setting confirmation indicators (old record)
      *
     D  OMDAT                  1      5  0
     D  ONIDT                  6     10  0
     D  ONRPD                 11     15  0
     D  OIFDY                 16     17  0
     D  OIPFR                 18     18
     D  ORDYN                 19     20  0
     D  ORFRQ                 21     21
     D  ORAMT                 22     34  0
     D  OSDST                 35     36  0
     D  STNOSX                37     38
     D***OOSDA**               37     48                                                      CGL029
     D  QQOSD1                37     48                                                       CGL029
     D  OTSTN                 49     58
     D  OFACO                 59     68
     D  OSPI1                 69     98
     D  OSPI2                 99    128
     D  OSPI3                129    158
     D  OSPI                  69    158
     D  OMDST                159    160  0
     D  MTNOSX               161    162
     D***OOMDA**              161    172                                                      CGL029
     D  QQOMD1               161    172                                                       CGL029
     D  OTMAN                173    182
     D  MATYX                159    182
     D  OINTR                183    193  7
     D  ORLDT                194    198  0
     D  ORLFQ                199    199
     D  ORLDY                200    201  0
     D  OOSDA                202    219                                                       CGL029
     D  OOMDA                220    237                                                       CGL029
     D  CONF1                  1     34
     D  LINK1                  6     34
     D  CONF2                 35    158
     D  LINK2                183    201
      *
     D  DataNewRcd     DS           500
      ***  Fields used in setting confirmation indicators (new record)
      *
     D  WSVMD                  1      5  0
     D  WSVID                  6     10  0
     D  WSVRP                 11     15  0
     D  WIFDY                 16     17  0
     D  SIPFR                 18     18
     D  WRDYN                 19     20  0
     D  SRFRQ                 21     21
     D  WSVRA                 22     34  0
     D  WSDST                 35     36  0
     D  STNOS                 37     38
     D***WOSDA**               37     48                                                      CGL029
     D  QQOSD2                37     48                                                       CGL029
     D  WTSTN                 49     58
     D  WFACO                 59     68
     D  DDSPI1                69     98
     D  DDSPI2                99    128
     D  DDSPI3               129    158
     D  DDSPI                 69    158
     D  WMDST                159    160  0
     D  MTNOS                161    162
     D***WOMDA**              161    172                                                      CGL029
     D  QQOMD2               161    172                                                       CGL029
     D  WTMAN                173    182
     D  WREC                 159    182
     D  WINTT                183    193  7
     D  WSVRD                194    198  0
     D  SRLFQ                199    199
     D  WRLDY                200    201  0
     D  WOSDA                202    219                                                       CGL029
     D  WOMDA                220    237                                                       CGL029
     D  CONFS1                 1     34
     D  LINKS1                 6     34
     D  CONFS2                35    158
     D  LINKS2               183    201
      *
      * Used for AONOSTR0
     D                 DS
     D***WOURS**                1     12                                                      CGL029
     D  WOURS                  1     18                                                       CGL029
     D  SSIX                   1      6
     D***SACD***                7     10                                                      CGL029
     D***SASQ***               11     12                                                      CGL029
     D  SACD                   7     16                                                       CGL029
     D  SASQ                  17     18                                                       CGL029
     D  WSNOS                  1      2
     D  ANMKEY                 1     10
      *
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+
      *
     D PACCD           S             10A                                                      CGL029
     D CLE141          S              1A                                                      CLE141
     D BDCHolInd       S              7A                                                      CLE141
     D LoanBDC         S             60A                                                      CLE141
     D DayNo           S              5  0                                                    CLE141
      *
      ** +--------------------------------------+
      **   Rename fields                         
      **   =============                         
      ** +--------------------------------------+
      *
      *
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      **   Hook for non-core D-specs (all types)   
      **   also any I-specs (if necessary)         
      **   =====================================   
      ** +----------------------------------------+
      /COPY WNCPYSRC,LECLIPEV02

      *
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+
      *

      /COPY WNCPYSRC,LECLIPVE03

      *
      ***  Extra Validation after Extended Settlement
      *    ==========================================

      *
      ***  Reset variables updated by each module
      *
     C                   EXSR      RESETERRS
      *                                                                                     AR804863
      ** Skip validation process if action is reject.                                       AR804863
      *                                                                                     AR804863
     C     @ACTRV        IFEQ      'Y'                                                      AR804863
     C                   RETURN                                                             AR804863
     C                   ENDIF                                                              AR804863
      *
      ***  Get start and maturity settlements
      *
      /COPY WNCPYSRC,LECLIPEV04
      *
     C                   EXSR      SRGLOC
      *
      /COPY WNCPYSRC,LECLIPEV05
      *
      ***  Validate Dates
      *
     C                   EXSR      SRDATE
      *
      /COPY WNCPYSRC,LECLIPEV06
      *
      ***  Validate Holidays
      *
     C                   EXSR      SRHOLY
      *
      /COPY WNCPYSRC,LECLIPEV07
      *
      ***  Update error information with that received back
      ***  from each validation module.
      *
     C                   EXSR      UPDATERRS
      *
      ***  Return
      *    ======
     C                   RETURN
      *
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRDATE - Validate Dates                                      *
      *****************************************************************
     C     SRDATE        BEGSR
      *
      ** Validate next interest payment date
      *
     C     DDACTN        IFEQ      'I'
     C     DDIPFR        IFNE      *BLANK
     C     DDMDAT        ANDNE     *BLANKS
     C     DDMDATOK      ANDNE     'N'
      *
      ** ... If interest frequency is entered, next interest date
      ** calculated should be on or earlier than maturity date
      ** N.B. do not do this when frequency = "R"
      ** Do not calc/validate next frequency if this is a transfer.
      *
     C     DDNIDT        IFNE      *BLANKS
     C     DDNIDTOK      ANDNE     'N'
     C     DDIPFROK      ANDNE     'N'
     C     DDIFDYOK      ANDNE     'N'
     C     DDIPFR        ANDNE     'R'
      *
      ** and this is not a transfer.
      *
     C     PGNTF         IFNE      'Y'
     C     RespMode      ANDEQ     'S'
      *
     C                   MOVE      W@MDSL        ZLOC
     C                   MOVE      DDIFDY        ZMDAY
     C                   CALLB     'ZFREQB'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      DDIPFR        ZFREQ             1
     C                   PARM      WSVID         ZDAYNO            5 0
     C                   PARM      DDCURR        ZCCY              3
     C                   PARM                    ZLOC                                       AR702741
     C                   PARM                    ZMDAY             2 0
     C                   PARM                    BJDFIN
     C                   PARM      SDGELR        SDGELR
     C     ZDAYNO        IFGT      WSVMD
     C                   MOVE      'N'           DDIPFROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDIPFR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0054'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Validate next repayment date
      *
     C     DDRFRQ        IFNE      *BLANK
     C     DDMDAT        ANDNE     *BLANKS
     C     DDMDATOK      ANDNE     'N'
      *
      ** ... If repayment frequency is entered, next repayment date
      ** calculated should be on or earlier than maturity date
      *
     C     DDNRPD        IFNE      *BLANKS
     C     DDNRPDOK      ANDNE     'N'
     C     DDRFRQOK      ANDNE     'N'
     C     DDRDYNOK      ANDNE     'N'
     C                   MOVE      W@MDSL        ZLOC
     C                   MOVE      DDRDYN        ZMDAY
                                                                                            BUG21836
     C                   CALLB     'ZFRQB3'                                                 BUG21836
     C                   PARM      DDRFRQ        ZFREQ                                      BUG21836
     C                   PARM      WSVRP         ZDAYNO                                     BUG21836
     C                   PARM                    ZMDAY                                      BUG21836
     C                   PARM      DDCURR        ZCCY                                       BUG21836
     C                   PARM                    ZLOC              3                        BUG21836
     C                   PARM                    ZZERR@            7                        BUG21836
     C                   Z-ADD     *ZERO         ZNRDYS            2 0                      BUG21836
                                                                                            BUG21836
     C                   SELECT                                                             BUG21836
      *                                                                                     BUG21836
      ** If payment is due on actual day, return the same date even if holiday              BUG21836
      ** If payment is due on the previous day, find previous working day;                  BUG21836
      ** Otherwise, find next working day                                                   BUG21836
      *                                                                                     BUG21836
     C     DDPDDI        WHENEQ    'P'                                                      BUG21836
                                                                                            BUG21836
     C                   CALLB     'ZBKDT'                                                  BUG21836
     C                   PARM                    ZDAYNO                                     BUG21836
     C                   PARM      DDCURR        ZCCY                                       BUG21836
     C                   PARM                    ZLOC                                       BUG21836
     C                   PARM                    ZNRDYS                                     BUG21836
     C                   PARM                    ZDYNBR            5 0                      BUG21836
                                                                                            BUG21836
     C                   MOVE      ZDYNBR        ZDAYNO                                     BUG21836
                                                                                            BUG21836
     C     DDPDDI        WHENEQ    'N'                                                      BUG21836
     C     DDPDDI        OREQ      *BLANK                                                   BUG21836
                                                                                            BUG21836
     C                   CALLB     'ZFWDT'                                                  BUG21836
     C                   PARM                    ZDAYNO                                     BUG21836
     C                   PARM                    ZNRDYS                                     BUG21836
     C                   PARM                    ZDYNBR                                     BUG21836
     C                   PARM      DDCURR        ZCCY                                       BUG21836
     C                   PARM                    ZLOC                                       BUG21836
                                                                                            BUG21836
     C                   MOVE      ZDYNBR        ZDAYNO                                     BUG21836
                                                                                            BUG21836
     C     DDPDDI        WHENEQ    'M'                                                      BUG21836
                                                                                            BUG21836
     C                   CALLB     'ZFREQB'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      DDRFRQ        ZFREQ             1
     C                   PARM      WSVRP         ZDAYNO            5 0
     C                   PARM      DDCURR        ZCCY              3
     C                   PARM                    ZLOC                                       AR702741
     C                   PARM                    ZMDAY             2 0
     C                   PARM                    BJDFIN
     C                   PARM      SDGELR        SDGELR
                                                                                            BUG21836
     C                   ENDSL                                                              BUG21836
                                                                                            BUG21836
     C     ZDAYNO        IFGT      WSVMD
     C                   MOVE      'N'           DDRFRQOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRFRQ'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0054'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRHOLY - Validate Holidays                                   *
      *****************************************************************
     C     SRHOLY        BEGSR

      *
      ** Holiday validations if loan currency is valid
      ** Test loan currency holiday for settlements 01, 07 and 08
      ** Otherwise, test for local currency holidays
      *
     C     DDCURROK      IFNE      'N'
      *
      ** Test value date for holiday
      *
     C     DDVDATOK      IFNE      'N'
     C     DDVDAT        ANDNE     *BLANKS
                                                                                224368
     C     DDACTN        IFNE      'I'                                          224368
     C     WSVVD         ANDGE     BJRDNB                                       224368
     C     DDACTN        OREQ      'I'                                          224368
     C                   Z-ADD     WSVVD         ZDAYNO
      *
     C     WSDST         IFEQ      1
     C     WSDST         OREQ      7
     C     WSDST         OREQ      8
     C                   MOVE      '1'           *IN97
      *
     C     CLE031        IFNE      'Y'                                                        CLE031
     C     CEU004        IFEQ      'Y'
     C     PMPSCY        ANDNE     *BLANKS
     C                   MOVE      PMPSCY        ZCCY
     C                   ELSE
     C                   MOVE      DDCURR        ZCCY
     C                   ENDIF
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
     C                   MOVE      DDCURR        ZCCY                                         CLE031
      *                                                                                       CLE031
     C     LoanType      IFEQ      'PTSO'                                                     CLE031
     C     PMRSCY        ANDNE     *BLANKS                                                    CLE031
     C                   MOVE      PMRSCY        ZCCY                                         CLE031
     C                   ENDIF                                                                CLE031
     C     LoanType      IFNE      'PTSO'                                                     CLE031
     C     PMPSCY        ANDNE     *BLANKS                                                    CLE031
     C                   MOVE      PMPSCY        ZCCY                                         CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   MOVE      W@SDSL        ZLOC
     C                   ELSE
     C                   MOVE      '0'           *IN97
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      BJSLCD        ZLOC
     C                   ENDIF
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   PARM      *BLANK        ZIND              1
      *
     C     ZIND          IFEQ      'H'
     C*****WE012         IFEQ      *BLANK                                                    BUG4351
     C*****WE012         OREQ      'Y'                                                       BUG4351
     C*****WSVVD         ANDNE     W1VD                                                      BUG4351
     C**********         Z-ADD     WSVVD         W1VD              5 0                       BUG4351
     C**********         MOVE      'Y'           WE012             1                         BUG4351
     C                   MOVE      'W'           DDVDATOK
     C                   ADD       1             WId
     C                   MOVEL     'DDVDAT'      WFldNmXAr(WId)
     C     *IN97         IFEQ      '1'
     C     CEU004        IFEQ      'Y'
     C                   MOVEL     'LEL0501'     WMsgIDXAr(WId)
     C                   ELSE
     C                   MOVEL     'LEL0067'     WMsgIDXAr(WId)
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'LEL0068'     WMsgIDXAr(WId)
     C                   ENDIF
     C**********         ENDIF                                                               BUG4351
     C                   ENDIF
     C                   ENDIF                                                  224368
     C                   ENDIF
      *
      ** Test maturity date for holiday
      *
     C     DDMDATOK      IFNE      'N'
     C     DDMDAT        ANDNE     *BLANKS
     C                   Z-ADD     WSVMD         ZDAYNO
      *
     C     WMDST         IFEQ      1
     C     WMDST         OREQ      7
     C     WMDST         OREQ      8
     C                   MOVE      '1'           *IN97
      *
     C     CLE031        IFNE      'Y'                                                        CLE031
     C     CEU004        IFEQ      'Y'
     C     PMPSCY        ANDNE     *BLANKS
     C                   MOVE      PMPSCY        ZCCY
     C                   ELSE
     C                   MOVE      DDCURR        ZCCY
     C                   ENDIF
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
     C                   MOVE      DDCURR        ZCCY                                         CLE031
      *                                                                                       CLE031
     C     LoanType      IFEQ      'PTSO'                                                     CLE031
     C     PMPSCY        ANDNE     *BLANKS                                                    CLE031
     C                   MOVE      PMPSCY        ZCCY                                         CLE031
     C                   ENDIF                                                                CLE031
     C     LoanType      IFNE      'PTSO'                                                     CLE031
     C     PMRSCY        ANDNE     *BLANKS                                                    CLE031
     C                   MOVE      PMRSCY        ZCCY                                         CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   MOVE      W@MDSL        ZLOC
     C                   ELSE
     C                   MOVE      '0'           *IN97
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      BJSLCD        ZLOC
     C                   ENDIF
      *
      ***Use*core*holiday*validation*when*CLE141*is*OFF*or*************               CLE141 CLE141A
      ***settlement*type*not*equal*to*01,*07*or*08*********************               CLE141 CLE141A
      *****************************************************************               CLE141 CLE141A
     C**********         IF        CLE141 = 'N' or *IN97 = '0'                        CLE141 CLE141A
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   PARM      *BLANK        ZIND              1
     C     ZIND          IFEQ      'H'
     C*****WE045         IFEQ      *BLANK                                                    BUG4351
     C*****WE045         OREQ      'Y'                                                       BUG4351
     C*****WSVMD         ANDNE     W1MD                                                      BUG4351
     C**********         Z-ADD     WSVMD         W1MD              5 0                       BUG4351
     C**********         MOVE      'Y'           WE045             1                         BUG4351
     C                   MOVE      'W'           DDMDATOK
     C                   ADD       1             WId
     C                   MOVEL     'DDMDAT'      WFldNmXAr(WId)
     C     *IN97         IFEQ      '1'
      *
     C     CEU004        IFEQ      'Y'
     C                   MOVEL     'LEL0502'     WMsgIDXAr(WId)
     C                   ELSE
     C                   MOVEL     'LEL0070'     WMsgIDXAr(WId)
     C                   ENDIF
      *
     C                   ELSE
     C                   MOVEL     'LEL0071'     WMsgIDXAr(WId)
     C                   ENDIF
     C**********         ENDIF                                                               BUG4351
     C                   ENDIF
     C**********         ENDIF                                                        CLE141 CLE141A
                                                                                              CLE141
      ** If CLE141 is ON, validate holiday with Business Day Convention                       CLE141
      ** for interest and principal payments                                                  CLE141
                                                                                              CLE141
     C**********         IF        CLE141 = 'Y'                                       CLE141 CLE141A
     C**********         IF        WMDST = 1 or WMDST = 7 or                          CLE141 CLE141A
     C**********                   WMDST = 8                                          CLE141 CLE141A
     C                   IF        CLE141 = 'Y' and CurLocPI <> *BLANKS                      CLE141A
     C                   CALLB     'LEVBDYLE'                                                 CLE141
     C                   PARM      *BLANKS       BDCHolInd                                    CLE141
     C                   PARM      CurLocPI      LoanBDC                                      CLE141
     C                   PARM      WSVMD         DayNo                                        CLE141
     C                   IF        BDCHolInd = 'HOLIDAY'                                      CLE141
     C                   EVAL      DDMDATOK = 'W'                                             CLE141
     C                   EVAL      WId = WId + 1                                              CLE141
     C                   EVAL      WFldNmXAr(WId) = 'DDMDAT'                                  CLE141
     C                   EVAL      WMsgIDXar(WId) = '5048508'                                 CLE141
     C                   ENDIF                                                                CLE141
     C                   ENDIF                                                                CLE141
     C**********         ENDIF                                                        CLE141 CLE141A
                                                                                              CLE141
     C                   ENDIF
      *
      ** Test interest payment date for holiday
      *
     C     DDNIDTOK      IFNE      'N'
     C     DDNIDT        ANDNE     *BLANKS
     C                   Z-ADD     WSVID         ZDAYNO
      *
     C     WMDST         IFEQ      1
     C     WMDST         OREQ      7
     C     WMDST         OREQ      8
     C                   MOVE      '1'           *IN97
      *
     C     CLE031        IFNE      'Y'                                                        CLE031
     C     CEU004        IFEQ      'Y'
     C     PMPSCY        ANDNE     *BLANKS
     C                   MOVE      PMPSCY        ZCCY
     C                   ELSE
     C                   MOVE      DDCURR        ZCCY
     C                   ENDIF
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
     C                   MOVE      DDCURR        ZCCY                                         CLE031
      *                                                                                       CLE031
     C     LoanType      IFEQ      'PTSO'                                                     CLE031
     C     PMPSCY        ANDNE     *BLANKS                                                    CLE031
     C                   MOVE      PMPSCY        ZCCY                                         CLE031
     C                   ENDIF                                                                CLE031
     C     LoanType      IFNE      'PTSO'                                                     CLE031
     C     PMRSCY        ANDNE     *BLANKS                                                    CLE031
     C                   MOVE      PMRSCY        ZCCY                                         CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   MOVE      W@MDSL        ZLOC
     C                   ELSE
     C                   MOVE      '0'           *IN97
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      BJSLCD        ZLOC
     C                   ENDIF
      *
      ***Use*core*holiday*validation*when*CLE141*is*OFF*or*************               CLE141 CLE141A
      ***settlement*type*not*equal*to*01,*07*or*08*********************               CLE141 CLE141A
      *****************************************************************               CLE141 CLE141A
     C**********         IF        CLE141 = 'N' or *IN97 = '0'                        CLE141 CLE141A
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   PARM      *BLANK        ZIND              1
     C     ZIND          IFEQ      'H'
     C*****WE078         IFEQ      *BLANK                                                    BUG4351
     C*****WE078         OREQ      'Y'                                                       BUG4351
     C*****WSVID         ANDNE     W1ID                                                      BUG4351
     C**********         Z-ADD     WSVID         W1ID              5 0                       BUG4351
     C**********         MOVE      'Y'           WE078             1                         BUG4351
     C                   MOVE      'W'           DDNIDTOK
     C                   ADD       1             WId
     C                   MOVEL     'DDNIDT'      WFldNmXAr(WId)
     C     *IN97         IFEQ      '1'
      *
     C     CEU004        IFEQ      'Y'
     C                   MOVEL     'LEL0499'     WMsgIDXAr(WId)
     C                   ELSE
     C                   MOVEL     'LEL0073'     WMsgIDXAr(WId)
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'LEL0074'     WMsgIDXAr(WId)
     C                   ENDIF
     C**********         ENDIF                                                               BUG4351
     C                   ENDIF
     C**********         ENDIF                                                        CLE141 CLE141A
                                                                                              CLE141
      ** If CLE141 is ON, validate holiday with Business Day Convention                       CLE141
      ** for interest and principal payments                                                  CLE141
                                                                                              CLE141
     C**********         IF        CLE141 = 'Y'                                       CLE141 CLE141A
     C**********         IF        WMDST = 1 or WMDST = 7 or                          CLE141 CLE141A
     C**********                   WMDST = 8                                          CLE141 CLE141A
     C                   IF        CLE141 = 'Y' and CurLocPI <> *BLANKS                      CLE141A
     C                   CALLB     'LEVBDYLE'                                                 CLE141
     C                   PARM      *BLANKS       BDCHolInd                                    CLE141
     C                   PARM      CurLocPI      LoanBDC                                      CLE141
     C                   PARM      WSVID         DayNo                                        CLE141
     C                   IF        BDCHolInd = 'HOLIDAY'                                      CLE141
     C                   EVAL      DDNIDTOK = 'W'                                             CLE141
     C                   EVAL      WId = WId + 1                                              CLE141
     C                   EVAL      WFldNmXAr(WId) = 'DDNIDT'                                  CLE141
     C**********         EVAL      WMsgIDXar(WId) = '5048508'                        CLE141 MD039016
     C                   EVAL      WMsgIDXar(WId) = '5048559'                               MD039016
     C                   ENDIF                                                                CLE141
     C                   ENDIF                                                                CLE141
     C**********         ENDIF                                                        CLE141 CLE141A
                                                                                              CLE141
     C                   ENDIF
      *
      ** Test repayment date for holiday
      *
     C     DDNRPDOK      IFNE      'N'
     C     DDNRPD        ANDNE     *BLANKS
     C                   Z-ADD     WSVRP         ZDAYNO
      *
     C     WMDST         IFEQ      1
     C     WMDST         OREQ      7
     C     WMDST         OREQ      8
     C                   MOVE      '1'           *IN97
      *
     C     CLE031        IFNE      'Y'                                                        CLE031
     C     CEU004        IFEQ      'Y'
     C     PMPSCY        ANDNE     *BLANKS
     C                   MOVE      PMPSCY        ZCCY
     C                   ELSE
     C                   MOVE      DDCURR        ZCCY
     C                   ENDIF
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
     C                   MOVE      DDCURR        ZCCY                                         CLE031
      *                                                                                       CLE031
     C     LoanType      IFEQ      'PTSO'                                                     CLE031
     C     PMPSCY        ANDNE     *BLANKS                                                    CLE031
     C                   MOVE      PMPSCY        ZCCY                                         CLE031
     C                   ENDIF                                                                CLE031
     C     LoanType      IFNE      'PTSO'                                                     CLE031
     C     PMRSCY        ANDNE     *BLANKS                                                    CLE031
     C                   MOVE      PMRSCY        ZCCY                                         CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   MOVE      W@MDSL        ZLOC
     C                   ELSE
     C                   MOVE      '0'           *IN97
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      BJSLCD        ZLOC
     C                   ENDIF
      *
      ***Use*core*holiday*validation*when*CLE141*is*OFF*or*************               CLE141 CLE141A
      ***settlement*type*not*equal*to*01,*07*or*08*********************               CLE141 CLE141A
      *****************************************************************               CLE141 CLE141A
     C**********         IF        CLE141 = 'N' or *IN97 = '0'                        CLE141 CLE141A
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   PARM      *BLANK        ZIND              1
     C     ZIND          IFEQ      'H'
     C*****WE034         IFEQ      *BLANK                                                    BUG4351
     C*****WE034         OREQ      'Y'                                                       BUG4351
     C*****WSVRP         ANDNE     W1RP                                                      BUG4351
     C**********         Z-ADD     WSVRP         W1RP              5 0                       BUG4351
     C**********         MOVE      'Y'           WE034             1                         BUG4351
     C                   MOVE      'W'           DDNRPDOK
     C                   ADD       1             WId
     C                   MOVEL     'DDNRPD'      WFldNmXAr(WId)
     C     *IN97         IFEQ      '1'
      *
     C     CEU004        IFEQ      'Y'
     C                   MOVEL     'LEL0500'     WMsgIDXAr(WId)
     C                   ELSE
     C                   MOVEL     'LEL0077'     WMsgIDXAr(WId)
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     'LEL0078'     WMsgIDXAr(WId)
     C                   ENDIF
     C**********         ENDIF                                                               BUG4351
     C                   ENDIF
     C**********         ENDIF                                                        CLE141 CLE141A
                                                                                              CLE141
      ** If CLE141 is ON, validate holiday with Business Day Convention                       CLE141
      ** for interest and principal payments                                                  CLE141
                                                                                              CLE141
     C**********         IF        CLE141 = 'Y'                                       CLE141 CLE141A
     C**********         IF        WMDST = 1 or WMDST = 7 or                          CLE141 CLE141A
     C**********                   WMDST = 8                                          CLE141 CLE141A
     C                   IF        CLE141 = 'Y' and CurLocPI <> *BLANKS                      CLE141A
     C                   CALLB     'LEVBDYLE'                                                 CLE141
     C                   PARM      *BLANKS       BDCHolInd                                    CLE141
     C                   PARM      CurLocPI      LoanBDC                                      CLE141
     C                   PARM      WSVRP         DayNo                                        CLE141
     C                   IF        BDCHolInd = 'HOLIDAY'                                      CLE141
     C                   EVAL      DDNRPDOK = 'W'                                             CLE141
     C                   EVAL      WId = WId + 1                                              CLE141
     C                   EVAL      WFldNmXAr(WId) = 'DDNRPD'                                  CLE141
     C**********         EVAL      WMsgIDXar(WId) = '5048508'                        CLE141 MD039016
     C                   EVAL      WMsgIDXar(WId) = '5048560'                               MD039016
     C                   ENDIF                                                                CLE141
     C                   ENDIF                                                                CLE141
     C**********         ENDIF                                                        CLE141 CLE141A
                                                                                              CLE141
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRGLOC  -  Get start and maturity date settlement             *
      *****************************************************************
     C     SRGLOC        BEGSR
      *
      ** For type 01,02,07,08 or 12, settlement location is determined
      ** by the nostro branch
      *
     C                   MOVE      *BLANKS       W@SDSL            3
     C                   MOVE      *BLANKS       W@MDSL            3
      *
      ** Get start settlement location
      *
     C                   MOVE      'S'           WTYPE             1                          CLE031
     C     WSDST         LOOKUP    WNOST                                  97
     C     *IN97         IFEQ      '1'
     C                   MOVE      WOSDA         WOURS
     C                   EXSR      SRSLOC
     C                   MOVE      W@STBL        W@SDSL
     C                   ENDIF
      *
      ** Get maturity settlement location
      *
     C                   MOVE      'E'           WTYPE                                        CLE031
     C     WMDST         LOOKUP    WNOST                                  97
     C     *IN97         IFEQ      '1'
     C                   MOVE      WOMDA         WOURS
     C                   EXSR      SRSLOC
     C                   MOVE      W@STBL        W@MDSL
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSLOC  -  Determine settlement locations                     *
      *****************************************************************
     C     SRSLOC        BEGSR
      *
     C                   MOVE      *BLANKS       W@STBL
      *
     C                   MOVE      WSNOS         PNONB
      *
     C     CLE031        IFNE      'Y'                                                        CLE031
     C     CEU004        IFEQ      'Y'
     C     PMPSCY        ANDNE     *BLANKS
     C                   MOVE      PMPSCY        PCURR
     C                   ELSE
     C                   MOVE      DDCURR        PCURR
     C                   ENDIF
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
      *                                                                                       CLE031
     C                   MOVE      DDCURR        PCURR                                        CLE031
     C     WTYPE         IFEQ      'S'                                                        CLE031
      *                                                                                       CLE031
     C     LoanType      IFEQ      'PTSO'                                                     CLE031
     C     PMRSCY        ANDNE     *BLANKS                                                    CLE031
     C                   MOVE      PMRSCY        PCURR                                        CLE031
     C                   ENDIF                                                                CLE031
     C     LoanType      IFNE      'PTSO'                                                     CLE031
     C     PMPSCY        ANDNE     *BLANKS                                                    CLE031
     C                   MOVE      PMPSCY        PCURR                                        CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
      *                                                                                       CLE031
     C     LoanType      IFEQ      'PTSO'                                                     CLE031
     C     PMPSCY        ANDNE     *BLANKS                                                    CLE031
     C                   MOVE      PMPSCY        PCURR                                        CLE031
     C                   ENDIF                                                                CLE031
     C     LoanType      IFNE      'PTSO'                                                     CLE031
     C     PMRSCY        ANDNE     *BLANKS                                                    CLE031
     C                   MOVE      PMRSCY        PCURR                                        CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM                    PCUSN             6
     C                   PARM                    PCURR             3
     C**********         PARM                    PACCD             4                          CGL029
     C                   PARM                    PACCD                                        CGL029
     C                   PARM                    PACSN             2
     C                   PARM                    PNONB             2
     C                   PARM                    PBRCA             3
     C                   PARM                    PCSSN            10
     C                   PARM                    PPNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
     C     WSNOS         IFEQ      '?'
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      A7NOSN        W@STBL            3
     C                   MOVEL     PNONB         WSNOS
     C                   ENDIF
     C                   ELSE
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVE      A7NOSN        W@STBL
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  #TERM - Termination processing.                              *
      *****************************************************************
     C     #TERM         BEGSR
      *
      ***  Terminate program
      *
     C                   MOVE      '1'           *INLR
      *
     C     *INU7         IFEQ      '1'
     C                   DUMP
     C                   END
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  RESETERRS - Reset error information that is received back    *
      *              from each validation module.                     *
      *****************************************************************
      *
     C     RESETERRS     BEGSR
      *
     C                   EVAL      RetCodeOut = *BLANKS
      *
      ***  Reset error & warning fields/message IDs/message data (arrays)
      *
     C                   MOVEL     *BLANK        FldNamXAr
     C                   MOVEL     *BLANK        MsgIDXAr
     C                   MOVEL     *BLANK        MsgDtaXAr
     C                   MOVEL     *BLANK        WFldNmXAr
     C                   MOVEL     *BLANK        WMsgIDXAr
     C                   MOVEL     *BLANK        WMsgDtXAr
                                                                                             BUG5863
      ** Reset Index of Warning errors.                                                      BUG5863
                                                                                             BUG5863
     C                   EVAL      WId = *ZERO                                               BUG5863
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  UPDATERRS - Update error information with that received back *
      *              from each validation module.                     *
      *****************************************************************
     C     UPDATERRS     BEGSR
      *
      ***  Update error fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I                 3 0
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     FldNamXAr     FlDNameArr(I)
     C                   MOVEA     MsgIDXAr      MsgIdArr(I)
     C                   MOVEA     MsgDtaXAr     MsgDtaArr(I)
     C                   END
      *
      ***  Set Error Index
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    FldNameArr(I)                          99
     C     I             SUB       1             Idx
      *
      ***  Update warning fields/message IDs/message data (arrays)
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEA     WFldNmXAr     WFldNamArr(I)
     C                   MOVEA     WMsgIDXAr     WMsgIDArr(I)
     C                   MOVEA     WMsgDtXAr     WMsgDtaArr(I)
     C                   END
      *
      ***  Set Warning Index
      *
     C                   Z-ADD     1             I
     C     *BLANK        LOOKUP    WFldNamArr(I)                          99
     C*****I****         SUB       1             WId                                         BUG4351
     C     I             SUB       1             WIdx                                        BUG4351
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ***  Response mode (1A), from source system common header
     C                   PARM                    RespMode          1
      *
      ***  Loan details screen 1
     C                   PARM                    NwLnScnFmt1
      ***  Loan details screen 2
     C                   PARM                    NwLnScnFmt2
                                                                                              CLE141
      ** Business Day Convention Screen Detail                                                CLE141
     C                   PARM                    NwLnScnFmt7                                  CLE141
      *
      ***  Generated by Principal Transfer from PT Midas input
     C                   PARM                    PGNTF             1
      *
      ***  Pay Settlement Currency
     C                   PARM                    PMPSCY            3
      ***  Receive Settlement Currency                                                        CLE031
     C                   PARM                    PMRSCY            3                          CLE031
      ***  Loan Type                                                                          CLE031
     C                   PARM                    LoanType          4                          CLE031
      *
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    OKFlag1DS
     C                   PARM                    OKFlag2DS
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ***  Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C************       PARM                    WId                                         BUG4351
     C                   PARM                    WIdx                                        BUG4351
      *
      ***  Fields used in setting confirmation indicators (old record)
     C                   PARM                    DataOldRcd
      *
      ***  Fields used in setting confirmation indicators (new record)
     C                   PARM                    DataNewRcd
      *
      ***  Shared data
     C                   PARM                    TransData
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV            1                        AR804863
      *
      ***  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'LECLIPEVL'   DBPGM
     C                   OUT       LDA
      *
      *
      ***  Access Bank details via access program
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Access General Ledger details
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
E004 C                   ENDIF
      *
      ** Determine if EMU LE Settlement Currency Conversion
      ** Upgrade feature is installed
      *
     C                   MOVE      'N'           CEU004            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU004
     C                   END
                                                                                              CLE031
      ** Determine if Settlement Currency is installed                                        CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031            1                          CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE141
      ** Determine if CLE141 is installed                                                     CLE141
                                                                                              CLE141
     C                   MOVE      'N'           CLE141                                       CLE141
     C                   CALLB     'AOSARDR0'                                                 CLE141
     C                   PARM      *BLANKS       @RTCD                                        CLE141
     C                   PARM      '*VERIFY'     @OPTN                                        CLE141
     C                   PARM      'CLE141'      @SARD                                        CLE141
                                                                                              CLE141
     C     @RTCD         IFEQ      *BLANKS                                                    CLE141
     C                   MOVE      'Y'           CLE141                                       CLE141
     C                   ENDIF                                                                CLE141
      *
      ***  Program, module and procedure names for database error processing.
      ***  =================================================================
      ***  The following /COPY sets these values, and also defines LDA as
      ***  an external data area
      *
      /COPY WNCPYSRC,LECLIPEV08
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2002
** WNOST **      Table of settlements through nostros
0102070812
