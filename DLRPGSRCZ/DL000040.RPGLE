     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Bulk Short Term Amendments')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL000040   - Bulk Short Term Rate Amendments                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 245692             Date 10Dec13               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7162            Date 13May05               *
      *                 CDL027  *CREATE    Date 10Feb05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD-23981.                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7162- Do not show matured deals (RECI = 'M') on the       *
      *           second screen.                                      *
      *  CDL027 - Back-valued base rate changes                       *
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
      * 21 - Currency Code                                            *
      * 22 - Base Rate Code                                           *
      * 23 - Short Term Rate                                          *
      * 24 - Value Date                                               *
      * 25 - Value Date: Holiday warning                              *
      * 40 - Deals record not found                                   *
      * 41 - Deals record locked                                      *
      * 66 - General Error                                            *
      * 66 - Test Numeric                                             *
      * 68 - Test Numeric                                             *
      * 94 - MSGSFLCTL EOF                                            *
      * 95 - Read SFL                                                 *
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
 
     FDL000040DFCF   E             WORKSTN
     F                                     SFILE(dl0040S1:@@RRN)
      ** Bulk Short Rate Amendments display file
 
     FDLIRLFL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLIRLFD0:DG)
      ** RTV: IRS Last Interest Rate Fix File
 
     FDEALALL   UF   E           K DISK    INFSR(*PSSR)
     F                                     ignore(DEALSDAf)
     F                                     ignore(DEALSDBf)
     F                                     ignore(DEALSDCf)
     F                                     ignore(DEALSDDf)
     F                                     ignore(DEALSDEf)
     F                                     ignore(DEALSDFf)
     F                                     RENAME(DEALSDGF:IRS)
      ** RTV: Midas IRS Deals File
 
     FDLIRHFPD  O    E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DLIRHFD0:HISTORY)
      ** OUT: IRS Back-valued Rate Fix History File
 
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
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  245692
     D QQACC1        E                     EXTFLD(QQACCD)                                     245692
      ** Data Structure to retrieve DEALING ICD details                                       245692
                                                                                              245692
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D                 DS
     D  ddmmyy                 1      6  0
     D  dd                     1      2  0
     D  mm                     3      4  0
     D  yy                     5      6  0
 
     D rtchgstr        DS
     D  rtchgstrd              1      5
 
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
 
                                                                                              245692
      ** Parameter list for ZA0840                                                            245692
      ** =========================                                                            245692
      ** Return code for numeric validation module call                                       245692
     D @Rtcde          S             10A                                                      245692
      ** Alpha field for numeric validation                                                   245692
     D @@ALPH          S             16A                                                      245692
      ** Number of decimal places field for numeric validation                                245692
     D @@IDP           S              2  0                                                    245692
      ** Number of integers field for numeric validation                                      245692
     D @@IINT          S              2  0                                                    245692
      ** Millions/Thousands id (Y=function on)                                                245692
     D @@MTID          S              1A                                                      245692
      ** Amount calculation field                                                             245692
     D @@AMT           S             15  0                                                    245692
      ** Error return code for ZA0840 module                                                  245692
     D @@ERCD          S              1  0                                                    245692
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
     c                   dou       *inkc=*on
      *
      * Display and validate the 1st screen (main prompt):
      *
     c                   exsr      sr_screen1
     c   kc              leave
      *
      * Display and validate the 2nd screen (subfile):
      *
     c  n66              exsr      sr_screen2
     c   kc              leave
     c   kl              iter
      *
      * Update data base
      *
     c                   if        *inki=*on
     c     @@cnt         casne     *zeros        sr_apply
     c                   endcs
     c                   iter
     c                   endif
      *
     c                   enddo
      *
      * End program
      *
     c                   exsr      sr_endpgm
      *
     c/eject
      *****************************************************************
     csr   sr_screen1    begsr
      *****************************************************************
      *
      * Initialize screen fields
      *
     c                   exsr      sr_inits1
      *
      * Process until Command 3 (kc) is pressed
      *
     c                   dou       *inkc=*on
      *
      * Display screen 1
      *
     c  n66              write     dl0040mb
     c   66              write     dl0040mc
     c                   exfmt     dl0040r1
      *
      * Clear error messages
      *
     c                   exsr      zaclms
      *
     c   kc              leave
      *
      * Validate screen 1: if errors (*IN66) -
      * redisplay
      *
     c                   exsr      sr_valids1
      *
     c                   select
     c                   when      *in66=*on
     c                   iter
     c                   other
     c                   leave
     c                   endsl
      *
     c                   enddo
      *
     csr                 endsr
      *
     c/eject
      *****************************************************************
     csr   sr_inits1     begsr
      *****************************************************************
      *
     c                   eval      #1ccy=*blanks
     c                   eval      #1ccyd=*blanks
     c                   eval      #1bsrc=*blanks
     c                   eval      #1bsrn=*blanks
     c                   eval      #1strt=*blanks
     c                   eval      #1vdat=*blanks
     c                   eval      svvdat=*blanks
      *
     c                   movea     '00000'       *in(21)
     c  nki              eval      *in66=*off
      *
     csr                 endsr
      *
     c/eject
      *****************************************************************
     csr   sr_valids1    begsr
      *****************************************************************
      *
     c                   movea     '0000'        *in(21)
     c                   eval      *in66=*off
      *
     c                   exsr      sr_ccy
     c                   exsr      sr_bsrc
     c                   exsr      sr_strt
     c                   exsr      sr_vdat
      *
     csr                 endsr
      *
     c/eject
      *****************************************************************
     csr   sr_ccy        begsr
      *****************************************************************
      *
     c                   if        #1ccy=*blanks
      *
     C                   eval      #1ccyd = *blanks
     c                   seton                                        6621
     c                   MOVEL     'MMM0142'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     c                   EXSR      ZASNMS
      *
     c                   else
      *
     C                   CALLb     'ZAVCURCODE'
     C                   PARM      *blanks       RetCodeIn
     C                   PARM      *blanks       Msgid1            7
     C                   PARM      #1ccy         DDCCY             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        RetCodeIn  = 'Error' or ddccy=*blanks
 
     C                   eval      #1ccyd = *blanks
     c                   seton                                        6621
     c                   MOVEL     'MMM0202'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     c                   EXSR      ZASNMS
 
     c                   else
 
     C                   eval      #1ccy  = A6CYCD
     C                   eval      #1ccyd = A6CYNM
 
     C                   endif
      *
     C                   endif
      *
     csr                 endsr
      *
     c/eject
      *****************************************************************
     csr   sr_bsrc       begsr
      *****************************************************************
      *
     c                   if        #1bsrc=*blanks
      *
     C                   eval      #1bsrn = *blanks
     c                   seton                                        6622
     c                   MOVEL     'CDL0001'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     c                   EXSR      ZASNMS
      *
     c                   else
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
     c                   seton                                        6622
     C                   MOVEL     'MMA0014'     zamsid
     C                   EVAL      #MsgFile = 'DRSMM'
     c                   EXSR      ZASNMS
 
     C                   else
 
     C                   eval      #1ccy  = @ucucy
     c                   exsr      sr_ccy
     c                   setoff                                       6621
     C                   eval      #1bsrc = babsrc
     C                   eval      #1bsrn = babsrn
     c                   move      #1bsrc        #1bsrc#           2 0
 
     C                   ENDIF
      *
     C                   ENDIF
      *
     csr                 endsr
      *
     c/eject
      *****************************************************************
     csr   sr_strt       begsr
      *****************************************************************
      *
     c                   if        #1strt=*blanks
      *
     c                   seton                                        6623
     c                   MOVEL     'MMA0055'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     c                   EXSR      ZASNMS
      *
     c                   else
      *
     C                   Z-ADD     0             @@AMT                                        245692
     C                   Z-ADD     0             @@ERCD                                       245692
     C                   MOVE      *BLANKS       @@MTID                                       245692
     C**********         MOVE      *BLANKS       ZFIELD                                       245692
     C**********         MOVE      #1strt        ZFIELD                                       245692
     C                   MOVE      *BLANKS       @@ALPH                                       245692
     C                   MOVE      #1strt        @@ALPH                                       245692
     C                   Z-ADD     7             @@IDP                                        245692
     C                   Z-ADD     4             @@IINT                                       245692
      *
     C**********         CALLb     'ZALIGN'                                                   245692
     C**********         PARM      *blanks       ZALIGNok                                     245692
     C**********         PARM                    ZFIELD                                       245692
     C**********         PARM      7             ZADEC                                        245692
     C**********         PARM      4             ZADIG                                        245692
     C                   CALLB     'ZA0840'                                                   245692
     C                   PARM                    @Rtcde                                       245692
     C                   PARM                    @@ALPH                                       245692
     C                   PARM                    @@IDP                                        245692
     C                   PARM                    @@IINT                                       245692
     C                   PARM                    @@MTID                                       245692
     C                   PARM                    @@ERCD                                       245692
     C                   PARM                    @@AMT                                        245692
     C                   PARM                    BNDCSP                                       245692
      *
     C*****ZALIGNok      IFEQ      'Y'                                                        245692
     C     @@ERCD        IFEQ      0                                                          245692
      *
     c**********         move      zfield        zfld15                                       245692
     c**********         move      zfield        #1strt#          11 7                        245692
     C                   move      @@AMT         zfld15                                       245692
     C                   move      @@AMT         #1strt#          11 7                        245692
     C                   Z-ADD     21            @@CRET                                       245692
      *
     C**********         callb     'ZFRPED'                                                   245692
     c**********         parm                    ZFLD15           15 0                        245692
     c**********         parm      7             ZDECS             1 0                        245692
     c**********         parm      'J'           ZECODE            1                          245692
     c**********         parm      *blanks       ZOUT22           22                          245692
     c**********         parm      *blanks       ZOUT25           25                          245692
     C                   CALLB     'ZA1020'                                                   245692
     C                   PARM                    ZFLD15           15 0                        245692
     C                   PARM                    @@CRET            2 0                        245692
     C                   PARM      7             @@CDP             1 0                        245692
     C                   PARM                    BNDCSP            1                          245692
     C                   PARM                    BNTHSP            1                          245692
     C                   PARM                    ZOUT21           21                          245692
      *
     C                   MOVE      *blanks       #1strt
     C**********         MOVE      ZOUT22        #1strt                                       245692
     C                   MOVE      ZOUT21        #1strt                                       245692
      *
     C                   ELSE
      *
     c                   seton                                        6623
     C                   MOVE      'MMA0034'     zamsid
     C                   EVAL      #MsgFile = 'DRSMM'
     c                   EXSR      ZASNMS
      *
     C                   endif
      *
     C                   endif
      *
     csr                 endsr
      *
     c/eject
      *****************************************************************
     csr   sr_vdat       begsr
      *****************************************************************
      *
     c                   do
      *
     c                   if        #1vdat=*blanks
     c                   seton                                        6624
     c                   MOVEL     'CDL0002'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     c                   EXSR      ZASNMS
     c                   leave
     c                   endif
      *
     c                   movea     '00'          *in(67)
     C                   testn                   #1vdat               6768
      *
     C                   if        *in67=*off and *in68=*off
     c                   seton                                        6624
     c                   MOVEL     'MMA0006'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     c                   EXSR      ZASNMS
     c                   leave
     c                   endif
      *
     C                   CALLb     'ZAVDATE'
     C                   PARM      *blanks       errorflag         7
     C                   PARM      #1vdat        ZDATE             6
     C                   PARM                    BJDFIN
     C                   PARM      *zeros        ZDAYNO            5 0
      *
     C                   if        errorflag <>*blanks
     c                   seton                                        6624
     c                   MOVEL     'MMA0006'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     c                   EXSR      ZASNMS
     c                   leave
     c                   endif
      *
     C                   MOVE      ZDAYNO        #1days            5 0
     c                   move      #1vdat        #2vdat            6 0
      *
      **  Check against the Rate Changes Start Date
      *
     c                   if        #1days<start
     c                   seton                                        6624
     c                   MOVEL     'CDL0008'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     C                   movel     start_days8   ZAMSDA
     c                   EXSR      ZASNMS
     c                   leave
     C                   ENDIF
      *
     c                   if        #1vdat<>svvdat
     c                   move      #1vdat        svvdat            6
      *
      **  Check if holiday.
      *
     C                   CALLb     'ZCHKH'
     C                   PARM                    #1days
     C                   PARM                    #1ccy
     C                   PARM                    ZLOC              3
     C                   PARM      *blanks       ZIND              1
      *
      **  If it is a holiday, display warning error (once per date)
      *
     C     ZIND          IFEQ      'H'
     c                   seton                                        6625
     c                   MOVEL     'CDL0003'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     c                   EXSR      ZASNMS
     C                   ENDIF
      *
     c                   endif
      *
     C                   leave
     c                   enddo
      *
     csr                 endsr
      *
     c/eject
      ********************************************************************
     csr   sr_screen2    begsr
      ********************************************************************
      *
      **  Initialise subfile relative record number.
      *
     C                   Z-ADD     *zeros        @@RRN             5 0
     C                   Z-ADD     *zeros        @@cnt
     c                   eval      *in66=*off
     c                   eval      *in96=*off
      *
      **  Clear subfile before refilling by writing control record
      **  with SFLCLR active.
      *
     C                   MOVE      *on           *IN97
     C                   WRITE     dl0040c1
     C                   MOVE      *off          *IN97
      *
      **  Set file pointer on key displayed on screen.
      *
     C     *loval        SETLL     dg
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
     c                   seton                                        66
     c                   EXSR      ZASNMS
     C                   eval      #2dlno=*blanks
     C                   eval      #2dtyp=*blanks
     C                   eval      #2outh=*blanks
     C                   eval      #2pamt=*blanks
     C                   z-add     1             @@RRN
     C                   Z-ADD     @@RRN         #1SFRN
     C                   WRITE     dl0040S1
     c                   goto      sfl_display
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
      *
      * Format Deal fields for output
      *
     C                   EXSR      sr_fmtsfl
      *
      **  Write the deal to the subfile.
      *
     C                   Z-ADD     @@RRN         #1SFRN
     C                   WRITE     dl0040S1
      *
      **  Read a valid deal
      *
     C                   EXSR      sr_deals
      *
     C                   enddo
      *
     c     sfl_display   tag
      *
      **  Write the select screen footer to the screen.
      **  Write the subfile control record to the screen to display
      **  the subfile.
      *
     C  n66              WRITE     dl0040mb
     C   66              WRITE     dl0040mc
     C                   WRITE     dl0040f1
     C                   WRITE     dl0040c1
      *
      **  Read the subfile control record to determine whether
      **  ROLLUP is required.
      *
     C                   READ      dl0040c1                               99
      *
      **  If F3, bypass further processing.
      *
     c   kc              exsr      sr_endpgm
      *
      * Clear error messages
      *
     c                   exsr      zaclms
      *
     c  nkl              iter
     c   kl              leave
     C                   ENDdo
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
     Csr   sr_fmtsfl     BEGSR
      ******************************************************************
      *
      * Deal number
      *
     C                   MOVE      a1dlno        #2dlno
      *
      * Deal type
      *
     C                   MOVE      a1dtyp        #2dtyp
      *
      * Ours/Theirs
      *
     C                   MOVE      a1side        #2side
      *
      * Our/Their Currency
      *
     c                   if        a1side='O'
     C                   MOVEl     'Our  '       #2outh
     c                   else
     C                   MOVEl     'Their'       #2outh
     c                   endif
      *
      * Base Rate Code
      *
     C                   MOVE      a1brcd        #2brcd
      *
      * Last Interest Rate Fix Date
      *
     C                   z-add     a1lifd        #2lifd
      *
      * Deal principal amount
      *
     c     *like         define    a1pram        pamt
     C                   MOVE      *blanks       #2pamt
      *
     c                   if        a1pram<>*zeros
      *
     c                   if        a1pram<*zeros
     c                   z-sub     a1pram        pamt
     c                   else
     c                   z-add     a1pram        pamt
     c                   endif
      *
     C                   Z-ADD     21            @@CRET                                       245692
     C**********         callb     'ZFRPED'                                                   245692
     c**********         parm      pamt          ZFLD15           15 0                        245692
     c**********         parm      A6NBDP        ZDECS             1 0                        245692
     c**********         parm      'J'           ZECODE            1                          245692
     c**********         parm      *blanks       ZOUT22           22                          245692
     c**********         parm      *blanks       ZOUT25           25                          245692
     C                   CALLB     'ZA1020'                                                   245692
     C                   PARM      pamt          ZFLD15                                       245692
     C                   PARM                    @@CRET            2 0                        245692
     C                   PARM      A6NBDP        @@CDP             1 0                        245692
     C                   PARM                    BNDCSP            1                          245692
     C                   PARM                    BNTHSP            1                          245692
     C                   PARM      *BLANKS       ZOUT21           21                          245692
      *
     C**********         MOVE      ZOUT22        #2pamt                                       245692
     C                   MOVE      ZOUT21        #2pamt                                       245692
      *
     c                   endif
      *
     Csr                 ENDSR
      *
      /EJECT
      *****************************************************************
     Csr   sr_deals      BEGSR
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
     C                   do
      *
     c     read_next     tag
      *
     C                   READ      dg                                     96
      *
      * If the record on DLIRLFPD has changed from LIVE to MATURED then do not               BUG7162
      * display on screen. £Note if there are any matured deals on DLIRLFPD                  BUG7162
      * then they will have come in as live deals via DL000050 and subsequently              BUG7162
      * matured.]                                                                            BUG7162
     C     *In96         Ifne      *On                                                       BUG7162
     C     A1DLNO        Chain     Irs                                40                     BUG7162
     C     *IN40         Ifeq      *OFF                                                      BUG7162
     C     RECI          andeq     'M'                                                       BUG7162
     c                   goto      read_next                                                 BUG7162
     C                   Endif                                                               BUG7162
     C                   Endif                                                               BUG7162
      *                                                                                      BUG7162
      * Check if qualifies for the display/update
      *
     c                   select
      *
      * Check if End of File
      *
     C                   when      *in96=*on
     C                   MOVEL     'Y'           @@EOF
     c                   leave
      *
      * Check if currency matches
      *
     c                   when      a1curc<>#1ccy
     c                   goto      read_next
      *
      * Check if base rate code matches
      *
     c                   when      a1brcd<>#1bsrc
     c                   goto      read_next
      *
      * Check if Interest Fix Date matches the value date entered
      *
     c                   when      a1lifd<>#1days
     c                   goto      read_next
      *
     c                   other
     c                   leave
      *
     c                   endsl
      *
     Csr                 ENDdo
      *
     C                   ENDSR
      *
      /EJECT
      *****************************************************************
     csr   sr_apply      begsr
      *****************************************************************
      *
     c                   eval      *in95=*off
      *
     c     *loval        setll     dg
      *
     c                   dou       *in41=*off
     c                   read      dg                                   4195
     c                   enddo
      *
     c                   dow       *in95=*off
      *
     c                   if        a1curc=#1ccy and a1brcd=#1bsrc and
     c                             a1lifd=#1days
      *
     c                   exsr      sr_update
      *
     c                   endif
      *
     c                   dou       *in41=*off
     c                   read      dg                                   4195
     c                   enddo
      *
     c                   enddo
      *
     C                   MOVEL     'CDL0004'     ZAMSID
     C                   EVAL      #MsgFile = 'DRSMM'
     c                   eval      *in66=*on
     c                   EXSR      ZASNMS
      *
     csr                 endsr
      *
     c/eject
      *****************************************************************
     Csr   sr_update     BEGSR
      ******************************************************************
      *
      * Deal number
      *
     C                   move      a1dlno        a2dlno
      *
      * Currency Code
      *
     C                   move      a1curc        a2curc
      *
      * Base Rate Code
      *
     C                   move      a1brcd        a2brcd
      *
      * Last Interest Rate Fix Date
      *
     C                   eval      a2lifd=#1days
      *
      * Old Short Term Interest Rate/Principal Amount
      *
     C                   dou       *in41=*off
     C     a2dlno        chain     irs                                4041
     C                   enddo
      *
     c                   if        *in40=*off and reci='D'
      *
     c                   if        a1side='O'
     C                   eval      a2osrt=ueinr
     C                   eval      ueinr=#1strt#
     C                   eval      a2pram=upamt
     C                   else
     C                   eval      a2osrt=teinr
     C                   eval      teinr=#1strt#
     C                   eval      a2pram=tpamt
     C                   endif
      *
      * Update Last Date Changed
      *
     C                   eval      lcd=BJRDNB
      *
      * Update DealsDG record
      *
     C                   update    irs
      *
     C                   endif
      *
      * New Short Term Interest Rate
      *
     C                   eval      a2nsrt=#1strt#
      *
      * Ours/Theirs
      *
     C                   move      a1side        a2side
      *
      * Write a history record
      *
     C                   write     history
      *
     Csr                 ENDSR
      *
     c/eject
      *****************************************************************
      * ZASNMS - Send Error Message
      *****************************************************************
     Csr   ZASNMS        BEGSR
      *
     c                   if        zapgmq=*blanks
     c                   eval      zapgmq=pgmq
     c                   endif
      *
     c                   call      'Y2SNMGC'
     c                   PARM                    ZAPGMQ           10
     c                   PARM                    ZAPGRL            5
     c                   PARM                    ZAMSID            7
     C                   PARM      #MsgFile      ZAMSGF           10
     C****               PARM      'XXUSRMSG  '  ZAMSGF           10
     C                   PARM                    ZAMSDA          132
     c                   PARM                    ZAMSTP            7
      *
     Csr                 ENDSR
      *
      /EJECT
      *****************************************************************
      * ZACLMS - Clear Error Messages
      *****************************************************************
     Csr   ZACLMS        BEGSR
      *
      * Clear messages from program message queue
      *
     C                   CALL      'Y2CLMSC'
     C                   PARM      dbpgm         ZAPGM            10
     C                   PARM      '*SAME'       ZAPGRL
      *
     Csr                 ENDSR
      *
      /EJECT
      *****************************************************************
      * End Program
      *****************************************************************
     Csr   sr_endpgm     BEGSR
      *
     c                   eval      *inlr=*on
     c                   return
      *
     Csr                 ENDSR
      *
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     Csr   *INZSR        BEGSR
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
     C                   PARM      'CDL0005'     MSGDNB            7
     C                   PARM      'DRSMM     '  MSGNM            10
     C                   PARM      *BLANK        TITLE            80
      *
     c                   movel     title         #1titl
      *
      ** Access switchable features
      *
     C                   CALLb     'AOSARDR0'
     C                   Parm      *Blanks       PRTCD             7
     C                   Parm      '*VERIFY'     POPTN             7
     C                   Parm      'CDL027'      PSARD             6
     C     SCSARD        Parm      SCSARD        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   z-add     1             DBASE
     C                   MOVEL     'CDL027'      DBKEY
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
      *                                                                                       245692
      ** Access Dealing ICD Details                                                           245692
      *                                                                                       245692
     C                   CALLB     'AODEALR0'                                                 245692
     C                   PARM      '*DBERR '     @RTCD             7                          245692
     C                   PARM      '*FIRST '     @OPTN             7                          245692
     C     SDDEAL        PARM      SDDEAL        DSFDY                                        245692
      *                                                                                       245692
     C     @RTCD         IFNE      *BLANKS                                                    245692
     C                   MOVEL     'SDDEALPD'    DBFILE                                       245692
     C                   z-add     4             DBASE                                        245692
     C                   MOVEL     @OPTN         DBKEY                                        245692
     C                   EXSR      *PSSR                                                      245692
     C                   ENDif                                                                245692
      *
      ** Retrieve data area for Back-valued Rate Changes Start Date
      *
     c     *dtaara       define    dlirsbvrts    rtchgstr
     c                   in        rtchgstr
     c                   move      rtchgstrd     start             5 0
     C                   move      *blanks       start_days8       8
      *
     C                   CALLb     'ZDATE2'
     C                   PARM                    start
     C                   PARM                    bjdfin
     C                   PARM      *ZEROS        date6             6 0
     C                   PARM      *BLANKS       midas7            7
      *
     c                   z-add     date6         ddmmyy
      *
     C                   move      dd            str_dd
     C                   move      '/'           str_slash1
     C                   move      mm            str_mm
     C                   move      '/'           str_slash2
     C                   move      yy            str_yy
      *
     Csr                 ENDSR
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
(c) Misys International Banking Systems Ltd. 2005
