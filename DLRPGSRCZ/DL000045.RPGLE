     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Historic Base Rate Amendments')               *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL000045   - Historic Base Rate Amendments                   *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL034  *CREATE    Date 08Mar05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL034 - Back-valued base rate changes                       *
      *                                                               *
      *****************************************************************
      * SUBROUTINES:                                                  *
      *****************************************************************
      *                                                               *
      * Standard:                                                     *
      * ---------                                                     *
      * *inzsr                                                        *
      * *pssr                                                         *
      * zaclms                                                        *
      * zasnms                                                        *
      *                                                               *
      * Custom:                                                       *
      * -------                                                       *
      * sr_apply                                                      *
      * sr_bsrc                                                       *
      * sr_ccy                                                        *
      * sr_deals                                                      *
      * sr_endpgm                                                     *
      * sr_fmtsfl                                                     *
      * sr_inits1                                                     *
      * sr_screen1                                                    *
      * sr_screen2                                                    *
      * sr_strt                                                       *
      * sr_update                                                     *
      * sr_valids1                                                    *
      * sr_vdat                                                       *
      *                                                               *
      *****************************************************************
      * INDICATOR USAGE                                               *
      *****************************************************************
      *                                                               *
      * 21 - Currency Code error                                      *
      * 22 - Base Rate Code error                                     *
      * 23 - Base Rate error                                          *
      * 24 - Value Date error                                         *
      * 25 - Value Date: Holiday warning                              *
      * 40 - Deals record not found                                   *
      * 41 - Deals record locked                                      *
      * 66 - General Error                                            *
      * 66 - Test Numeric                                             *
      * 68 - Test Numeric                                             *
      * 94 - MSGSFLCTL EOF                                            *
      * 95 - SFLDSP                                                   *
      * 96 - SFLEND                                                   *
      * 97 - SFLCLR                                                   *
      * 98 - deals file EOF/rollup                                    *
      * 99 - SFLCTL EOF                                               *
      * LR - Last Record                                              *
      * U7 - Error                                                    *
      * U8 - Error                                                    *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDL000045DFCF   E             WORKSTN
     F                                     SFILE(Dl0045S1:@@RRN)
      ** Bulk Short Rate Amendments display file
 
     FDealsL6   IF   E           K DISK    INFSR(*PSSR)
      ** RTV: Midas Deals File
 
     FDlDIRHl0  UF A E           K DISK    INFSR(*PSSR)
      ** UPD: Deal Interest Rate History File
 
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
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for Currency Details file
 
     D   SDBSRT      E DS                  EXTNAME(SDBSRTPD)
      **Base Rate Code details accessed via access programme
 
     D   ZADEC         S              1  0
      **Decimal data length passed as a parameter to ZALIGN
 
     D   ZADIG         S              2  0
      **Digital data length passed as a parameter to ZALIGN
 
     D   ZFIELD        S             16A
      **Field Passed to ZALIGN on which the work is done
 
     D   ZALIGNok      S              1A
      **Indicator to show whether or not ZALIGN was successful
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D                 DS
     D  ddmmyy                 1      6  0
     D  dd                     1      2  0
     D  mm                     3      4  0
     D  yy                     5      6  0
 
     D CDL034DS      E DS                  Extname(CDL034)
 
     D                 DS
     D  start_days8            1      8
     D  str_dd                 1      2
     D  str_slash1             3      3
     D  str_mm                 4      5
     D  str_slash2             6      6
     D  str_yy                 7      8
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D K_BRCd          S                   Like(BRTT)
     D K_DlNo          S                   Like(DlNo)
     D K_HisD          S                   Like(A2HisD)
 
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
      *
      * Process until Command 3 (kc) is pressed
      *
     C                   DoU       *InKC
      *
      * Display and validate the 1st screen (main prompt):
      *
     C                   exsr      sr_screen1
     C   kc              leave
      *
      * Display and validate the 2nd screen (subfile):
      *
     C  n66              exsr      sr_screen2
     C   kc              leave
     C   kl              iter
      *
      * Update data base
      *
     C                   if        *inki=*on
     C     @@cnt         casne     *zeros        sr_apply
     C                   endcs
     C                   iter
     C                   endif
      *
     C                   enddo
      *
      * End program
      *
     C                   exsr      sr_endpgm
      *
     C/eject
      *****************************************************************
     C     sr_screen1    begsr
      *****************************************************************
      *
      * Initialize screen fields
      *
     C                   exsr      sr_inits1
      *
      * Process until Command 3 (kc) is pressed
      *
     C                   dou       *inkc=*on
      *
      * Display screen 1
      *
     C  n66              write     Dl0045mb
     C   66              write     Dl0045mc
     C                   exfmt     Dl0045r1
      *
      * Clear error messages
      *
     C                   exsr      zaclms
      *
     C   kc              leave
      *
      * Validate screen 1: if errors (*IN66) -
      * redisplay
      *
     C                   exsr      sr_valids1
      *
     C                   select
     C                   when      *in66=*on
     C                   iter
     C                   other
     C                   leave
     C                   endsl
      *
     C                   enddo
      *
     C                   endsr
      *
     C/eject
      *****************************************************************
     C     sr_inits1     begsr
      *****************************************************************
      *
     C                   eval      #1ccy=*blanks
     C                   eval      #1ccyd=*blanks
     C                   eval      #1bsrc=*blanks
     C                   eval      #1bsrn=*blanks
     C                   eval      #1strt=*blanks
     C                   eval      #1vdat=*blanks
     C                   eval      svvdat=*blanks
      *
     C                   movea     '00000'       *in(21)
     C  nki              eval      *in66=*off
      *
     C                   endsr
      *
     C/eject
      *****************************************************************
     C     sr_valids1    begsr
      *****************************************************************
      *
     C                   movea     '0000'        *in(21)
     C                   eval      *in66=*off
      *
     C                   exsr      sr_ccy
     C                   exsr      sr_bsrc
     C                   exsr      sr_strt
     C                   exsr      sr_vdat
      *
     C                   endsr
      *
     C/eject
      *****************************************************************
     C     sr_ccy        begsr
      *****************************************************************
      *
     C                   if        #1ccy=*blanks
      *
     C                   eval      #1ccyd = *blanks
     C                   seton                                        6621
     C                   MOVEL     'MMM0142'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     C                   EXSR      ZASNMS
      *
     C                   else
      *
     C                   CALLb     'ZAVCURCODE'
     C                   PARM      *blanks       RetCodeIn
     C                   PARM      *blanks       Msgid1            7
     C                   PARM      #1ccy         DDCCY             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        RetCodeIn  = 'Error' or ddccy=*blanks
 
     C                   eval      #1ccyd = *blanks
     C                   seton                                        6621
     C                   MOVEL     'MMM0202'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     C                   EXSR      ZASNMS
 
     C                   else
 
     C                   eval      #1ccy  = A6CYCD
     C                   eval      #1ccyd = A6CYNM
 
     C                   endif
      *
     C                   endif
      *
     C                   endsr
      *
     C/eject
      *****************************************************************
     C     sr_bsrc       begsr
      *****************************************************************
      *
     C                   if        #1bsrc=*blanks
      *
     C                   eval      #1bsrn = *blanks
     C                   seton                                        6622
     C                   MOVEL     'CDL0001'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     C                   EXSR      ZASNMS
      *
     C                   else
      *
     C                   CALLb     'AOBSRTR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY'        @OPTN             7
     C                   PARM      #1ccy         @UCUCY            3
     C                   PARM      #1bsrc        @UBRTT            2
     C     SDBSRT        PARM      SDBSRT        DSSDY
 
     C     @RTCD         IFNE      *BLANK
     C     @ubrtt        oreq      *BLANK
     C                   eval      #1bsrn = *blanks
     C                   seton                                        6622
     C                   MOVEL     'MMA0014'     zamsid
     C                   EVAL      #MsgFile = 'DRSMM'
     C                   EXSR      ZASNMS
 
     C                   else
 
     C                   eval      #1ccy  = @ucucy
     C                   exsr      sr_ccy
     C                   setoff                                       6621
     C                   eval      #1bsrc = babsrc
     C                   eval      #1bsrn = babsrn
     C                   move      #1bsrc        #1bsrc#           2 0
 
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   endsr
      *
     C/eject
      *****************************************************************
     C     sr_strt       begsr
      *****************************************************************
      *
     C                   if        #1strt=*blanks
      *
     C                   seton                                        6623
     C                   MOVEL     'MMA0055'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     C                   EXSR      ZASNMS
      *
     C                   else
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      #1strt        ZFIELD
      *
     C                   CALLb     'ZALIGN'
     C                   PARM      *blanks       ZALIGNok
     C                   PARM                    ZFIELD
     C                   PARM      7             ZADEC
     C                   PARM      4             ZADIG
      *
     C     ZALIGNok      IFEQ      'Y'
      *
     C                   move      zfield        zfld15
     C                   move      zfield        #1strt#          11 7
      *
     C                   callb     'ZFRPED'
     C                   parm                    ZFLD15           15 0
     C                   parm      7             ZDECS             1 0
     C                   parm      'J'           ZECODE            1
     C                   parm      *blanks       ZOUT22           22
     C                   parm      *blanks       ZOUT25           25
      *
     C                   MOVE      *blanks       #1strt
     C                   MOVE      ZOUT22        #1strt
      *
     C                   ELSE
      *
     C                   seton                                        6623
     C                   MOVE      'MMA0034'     zamsid
     C                   EVAL      #MsgFile = 'DRSMM'
     C                   EXSR      ZASNMS
      *
     C                   endif
      *
     C                   endif
      *
     C                   endsr
      *
     C/eject
      *****************************************************************
     C     sr_vdat       begsr
      *****************************************************************
      *
     C                   do
      *
     C                   if        #1vdat=*blanks
     C                   seton                                        6624
     C                   MOVEL     'CDL0002'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     C                   EXSR      ZASNMS
     C                   leave
     C                   endif
      *
     C                   movea     '00'          *in(67)
     C                   testn                   #1vdat               6768
      *
     C                   if        *in67=*off and *in68=*off
     C                   seton                                        6624
     C                   MOVEL     'MMA0006'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     C                   EXSR      ZASNMS
     C                   leave
     C                   endif
      *
     C                   CALLb     'ZAVDATE'
     C                   PARM      *blanks       errorflag         7
     C                   PARM      #1vdat        ZDATE             6
     C                   PARM                    BJDFIN
     C                   PARM      *zeros        ZDAYNO            5 0
      *
     C                   if        errorflag <>*blanks
     C                   seton                                        6624
     C                   MOVEL     'MMA0006'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     C                   EXSR      ZASNMS
     C                   leave
     C                   endif
      *
     C                   MOVE      ZDAYNO        #1BVdate          5 0
     C                   move      #1vdat        #2vdat            6 0
      *
      **  Check against the Rate Changes Start Date
      *
     C                   if        #1BVdate < start
     C                   seton                                        6624
     C                   MOVEL     'CDL0008'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     C                   movel     start_days8   ZAMSDA
     C                   EXSR      ZASNMS
     C                   leave
     C                   ENDIF
      *
     C                   if        #1vdat<>svvdat
     C                   move      #1vdat        svvdat            6
      *
      **  Check if holiday.
      *
     C                   CALLb     'ZCHKH'
     C                   PARM                    #1BVdate
     C                   PARM                    #1ccy
     C                   PARM                    ZLOC              3
     C                   PARM      *blanks       ZIND              1
      *
      **  If it is a holiday, display warning error (once per date)
      *
     C     ZIND          IFEQ      'H'
     C                   seton                                        6625
     C                   MOVEL     'CDL0003'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     C                   EXSR      ZASNMS
     C                   ENDIF
      *
     C                   endif
      *
     C                   leave
     C                   enddo
      *
     C                   endsr
      *
     C/eject
      ********************************************************************
     C     sr_screen2    begsr
      ********************************************************************
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     *zeros        @@RRN             5 0
     C                   Z-ADD     *zeros        @@cnt
     C                   eval      *in66=*off
     C                   eval      *in95=*off
     C                   eval      *in96=*off
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      *on           *IN97
     C                   WRITE     Dl0045c1
     C                   MOVE      *off          *IN97
      *
      **  Set file pointer on key displayed on screen.
      *
     C                   Move      #1BsRC        K_BRCd
     C     KL_Cv0        SetLL     DealsDCf
      *
      **  Read a valid deal
      *
     C                   EXSR      sr_deals
      *
      **  If no records exist - set up an error message.
      *
     C     @@EOF         IFEQ      'Y'
     C                   MOVEL     'MMM1007'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     C                   seton                                        66
     C                   EXSR      ZASNMS
     C                   eval      #2dlno=*blanks
     C                   eval      #2dtyp=*blanks
     C                   eval      #2dlst=*blanks
     C                   eval      #2pamt=*blanks
     C                   z-add     1             @@RRN
     C                   Z-ADD     @@RRN         #1SFRN
     C                   WRITE     Dl0045S1
     C                   goto      sfl_display
     C                   ENDIF
      *
      **  Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      *on           *IN98
      *
      **  Read records from the file into the subfile until a page has
      **  been filled or there are no more records.
      **  Repeat the process until either the end of file, ROLLUP
      **  has not been entered or F3 or F12 is input.
      *
     C     @@EOF         DOWNE     'Y'
     C     *IN98         ANDEQ     *on
      *
      **  Initialise count of records written to subfile page.
      *
     C                   Z-ADD     *zeros        @@CNT             3 0
      *
      **  For each record read, write it to the subfile.
      **  Do this until end of file or the subfile page is full.
      *
     C     @@EOF         DOWNE     'Y'
     C     @@CNT         ANDLT     9
      *
      **  Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             @@RRN
     C                   ADD       1             @@CNT
     C                   Eval      *In95 = *On
      *
      * Format Deal fields for output
      *
     C                   EXSR      sr_fmtsfl
      *
      **  Write the deal to the subfile.
      *
     C                   Z-ADD     @@RRN         #1SFRN
     C                   WRITE     Dl0045S1
      *
      **  Read a valid deal
      *
     C                   EXSR      sr_deals
      *
     C                   enddo
      *
     C     sfl_display   tag
      *
      **  Write the select screen footer to the screen.
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C  n66              WRITE     Dl0045mb
     C   66              WRITE     Dl0045mc
     C                   WRITE     Dl0045f1
     C                   WRITE     Dl0045c1
      *
      **  Read the subfile control record to determine whether
      **  ROLLUP is required.
      *
     C                   READ      Dl0045c1                               99
      *
      **  If F3, bypass further processing.
      *
     C   kc              exsr      sr_endpgm
      *
      * Clear error messages
      *
     C                   exsr      zaclms
      *
     C  nkl              iter
     C   kl              leave
     C                   ENDdo
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
 
     C     Sr_FmtSfl     BegSr
 
      ** Deal number
 
     C                   Move      DlNo          #2DlNo
 
      ** Deal type
 
     C                   Move      DTyp          #2DTyp
 
      ** Deal sub-type
 
     C                   Move      DlSt          #2DlSt
 
      ** Base Rate Code
 
     C                   Move      BRTT          #2BRCd
 
      ** Rate/spread
 
     C                   Z-Add     RtSp          #2RtSp
 
      ** Interest calculation basis
 
     C                   Z-Add     ICBs          #2ICBs
 
      ** Last Interest Date
 
     C                   CallB     'ZDATE2'
     C                   PARM                    SLID
     C                   PARM                    BjDFin
     C                   PARM      *ZEROS        date6             6 0
     C                   PARM      *BLANKS       midas7            7
     C                   Move      Date6         #2SLID
 
      ** Deal principal amount
 
     C                   Z-Add     Pcpl          #2Pcpl
     C                   CallB     'ZFRPED'
     C                   parm      PCPL          ZFLD15           15 0
     C                   parm      A6NBDP        ZDECS             1 0
     C                   parm      'J'           ZECODE            1
     C                   parm      *blanks       ZOUT22           22
     C                   parm      *blanks       ZOUT25           25
      *
     C                   MOVE      ZOUT22        #2PAmt
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
     C     sr_deals      BEGSR
      *****************************************************************
      *
      **  Reset End of File indicator
      *
     C                   MOVE      *BLANK        @@EOF             1
      *
      **  Read the file initially - if @@EOF is set on then the end of
      **  the file has been reached.  Read until a valid record is
      **  found or until no more records exist.
      *
      **  Read the file.
      *
     C                   DoU       %EoF
 
     C     KL_Cv0        ReadE     DealsDCf                               96
 
      ** Check if End of File
 
     C                   If        %EoF
     C                   MOVEL     'Y'           @@EOF
     C                   Leave
     C                   EndIf
 
      ** Check if back-value date falls within current interest period
 
     C                   If        SLID <= #1BVdate
     C                   Leave
     C                   EndIf
 
     C                   EndDo
 
     C                   EndSr
      /EJECT
      *******************************************************************
      *
      *  Sr_Apply - To apply back-valued base rate change to selected
      *             Deals
      *
      *******************************************************************
 
     C     Sr_Apply      BegSr
 
      ** Read subfile
 
     C                   DoU       %EoF(Dl000045Df)
     C                   ReadC     Dl0045S1
 
      ** Update Deals Interest Rate History for selected deal
 
     C                   If        Not %EoF
     C                   ExSr      Sr_Update
     C                   EndIf
 
     C                   EndDo
 
     C                   MOVEL     'CDL0004'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     C                   eval      *in66=*on
     C                   EXSR      ZASNMS
 
     C                   EndSr
     C/eject
      *******************************************************************
      *
      *  Sr_Update - To update Deal Interest Rate History for deals tied
      *              to base rate
      *
      *******************************************************************
 
     C     Sr_Update     BegSr
 
      ** Set up IRH key for deal being updated
 
     C                   Move      #2BRCd        K_BRCd
     C                   Move      #2DlNo        K_DlNo
     C                   Move      #1BVdate      K_HisD
 
     C     KL_DIRH       SetLL     DlDIRHl0
     C     KL_DIRH       ReadE     DlDIRHl0
     C                   If        Not %EoF
     C                   Exsr      Update_IRH
     C                   Else
     C                   ExSr      Write_IRH
     C                   EndIf
 
     C                   EndSr
     C/eject
      *******************************************************************
      *
      *  Update_IRH - To update Deal Interest Rate History with
      *               back-valued base rate
      *
      *******************************************************************
 
     C     Update_IRH    BegSr
 
      ** Update current base rate and calculate new effective rate
 
     C                   Z-Add     #1StRt#       A2CBsR
     C                   Eval      A2IntR = A2CBsR + #2RtSp
 
     C                   Update    DlDIRHd0
 
     C                   EndSr
      /Eject
      *******************************************************************
      *
      *  Write_IRH -  To write new Deal Interest Rate History record for
      *               back-valued base rate
      *
      *******************************************************************
 
     C     Write_IRH     BegSr
 
      ** Check for prior IRH record to find correct principal in case of
      ** PI, PD amendments
 
     C     KL_DIRH2      ReadPE    DlDIRHl0
     C                   If        Not %EoF
     C                   Eval      #2Pcpl = A2Pcpl
     C                   EndIf
 
      ** Populate fields for new IRH record
 
     C                   Eval      A2RecI = 'D'
     C                   Move      #2DlNo        A2DlNo
     C                   Eval      A2HisD = #1BVdate
     C                   Eval      A2CyCd = #1Ccy
     C                   Eval      A2Pcpl = #2Pcpl
     C                   Move      #2BRCd        A2BRt
     C                   Z-Add     #1StRt#       A2CBsR
     C                   Eval      A2RtSp = #2RtSp
     C                   Eval      A2IntR = A2CBsR + #2RtSp
     C                   Eval      A2ICBs = #2ICBs
     C                   Eval      A2AInP = 0
     C                   Eval      A2AID1 = 0
     C                   Write     DlDIRHd0
 
     C                   EndSr
      /Eject
      *****************************************************************
      * ZASNMS - Send Error Message
      *****************************************************************
     C     ZASNMS        BEGSR
      *
     C                   if        zapgmq=*blanks
     C                   eval      zapgmq=pgmq
     C                   endif
      *
     C                   call      'Y2SNMGC'
     C                   PARM                    ZAPGMQ           10
     C                   PARM                    ZAPGRL            5
     C                   PARM                    ZAMSID            7
     C                   PARM      #MsgFile      ZAMSGF           10
     C****               PARM      'XXUSRMSG  '  ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     C                   PARM                    ZAMSTP            7
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * ZACLMS - Clear Error Messages
      *****************************************************************
     C     ZACLMS        BEGSR
      *
      * Clear messages from program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      dbpgm         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * End Program
      *****************************************************************
     C     sr_endpgm     BEGSR
      *
     C                   eval      *inlr=*on
     C                   return
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
 
     C     *InzSr        BEGSR
 
      ** Define key lists
 
     C     KL_Cv0        Klist
     C                   Kfld                    #1Ccy
     C                   Kfld                    K_BRCd
 
     C     KL_DIRH       Klist
     C                   Kfld                    #1Ccy
     C                   Kfld                    K_BRCd
     C                   Kfld                    K_DlNo
     C                   Kfld                    K_HisD
 
     C     KL_DIRH2      Klist
     C                   Kfld                    #1Ccy
     C                   Kfld                    K_BRCd
     C                   Kfld                    K_DlNo
      *
      ** Initialize program name
      *
     C                   MOVEL     PSProcPgm     DBPGM
     C                   MOVEL     PSProcPgm     #1PGM
     C                   MOVEL     PSProcPgm     pgmq
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     #1WID
      *
      ** Move User ID to screen field.
      *
     C                   MOVEL     PsUser        #1USER
      *
      ** Retrieve title
      *
     C                   CALL      'SDRTVTXT'
     C                   PARM      'CDL0009'     MSGDNB            7
     C                   PARM      'DRSMM     '  MSGNM            10
     C                   PARM      *BLANK        TITLE            80
      *
     C                   movel     title         #1titl
      *
      ** Access switchable features
      *
     C                   CALLb     'AOSARDR0'
     C                   Parm      *Blanks       PRTCD             7
     C                   Parm      '*VERIFY'     POPTN             7
     C                   Parm      'CDL034'      PSARD             6
     C     SCSARD        Parm      SCSARD        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   z-add     1             DBASE
     C                   MOVEL     'CDL034'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDif
      *
      ** Access bank Details
      *
     C                   CALLb     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   z-add     2             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDif
      *
      ** Access General Ledger Details
      *
     C                   CALLb     'AOGELRR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDGELR        PARM      SDGELR        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   z-add     3             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDif
      *
      ** Retrieve data area for Back-valued Rate Changes Start Date
      *
     C     *DtaAra       Define    CDL034        CDL034DS
     C                   In        CDL034DS
     C                   move      A2Day1        start             5 0
     C                   move      *blanks       start_days8       8
      *
     C                   CALLb     'ZDATE2'
     C                   PARM                    start
     C                   PARM                    bjdfin
     C                   PARM      *ZEROS        date6             6 0
     C                   PARM      *BLANKS       midas7            7
      *
     C                   z-add     date6         ddmmyy
      *
     C                   move      dd            str_dd
     C                   move      '/'           str_slash1
     C                   move      mm            str_mm
     C                   move      '/'           str_slash2
     C                   move      yy            str_yy
      *
     C                   ENDSR
      *
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
(c) Finastra International Limited 2005
