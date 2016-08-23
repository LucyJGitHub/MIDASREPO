     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*XBI *  OVRDBF FILE(FFD) TOFILE(QADSPFFD)                            *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Standing data authorisation compare')         *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDAUTHCMP - Standing Data Authorisation Compare              *
      *                                                               *
      *  Function:  This program displays the changes that have       *
      *             taken place.                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CMG003             Date 04Oct12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 239499             Date 24Apr06               *
      *                 BUG7323            Date 24May05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG5670            Date 05Apr05               *
      *                 BUG5780            Date 29Mar05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG2469            Date 06May04               *
      *                 CAAA03             Date 01Apr04               *
      *                 CAAA02             Date 15Jan04               *
      *                 CGL029             Date 03Sep01               *
      *                 CSD012  *CREATE    Date 15Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CMG003 - SWIFT MT600 Message Generation                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  239499 - For signed numeric fields, use ZASIGN for           *
      *           conversion.                                         *
      *  BUG7323- Dbase 3 Related to BUG5670.                         *
      *           Attempt to access Midas cust using a counterparty   *
      *           nostro                                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5670 - Customer Number displayed on authorisation of      *
      *            extended settlement instructions                   *
      *  BUG5780- Remove internal fields from authorisation display.  *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG2469- Dumps when there is no fields amended in the        *
      *           customer details during authorization.              *
      *  CAAA03 - Webfacing Changes (recompile)                       *
      *  CAAA02 - Web Facing - Swap Write Statements around           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSD012 - Standing Data Authorisation                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDAUTHCDF CF   E             WORKSTN
     F                                     SFILE(SUBFLREC:RRN)
      ** Midas SD Authorisation Compare Display
 
     FSDAULGL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Authorisation Log - by Key
 
     FSDAUEFPD  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Authorisation Extension File Names
 
     FSDAUFCPD  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Authorisation Fields to be Converted
 
     FSDAUFSL0  IF   E           K DISK    INFSR(*PSSR)                                      BUG5780
      ** Midas SD Authorisation Fields to be Suppressed                                      BUG5780
                                                                                             BUG5780
     FSDAUFDL0  IF A E           K DISK    INFSR(*PSSR)
      ** Midas SD Authorisation Field Data - by File, Seq, Field No.
 
     FFFD       IF   E           K DISK    USROPN
      ** Output file for DSPFFD
 
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D*ERR******       S             76    DIM(3) CTDATA PERRCD(1)                           BUG2469
     D ERR             S             76    DIM(4) CTDATA PERRCD(1)                           BUG2469
     D MMF             S              1    DIM(80) CTDATA PERRCD(80)
     D MEF             S              1    DIM(80) CTDATA PERRCD(80)
     D BIT             S              2  0 DIM(16) CTDATA PERRCD(16)
     D ALP             S              1    DIM(16) CTDATA PERRCD(16)
     D RETBD           S             30    DIM(7) CTDATA PERRCD(1)
     D***NARREP*         S             30    DIM(8) CTDATA PERRCD(1)                  BUG5780 CMG003
     D NARREP          S             30    DIM(10) CTDATA PERRCD(1)                           CMG003
 
     D UBA             S              1    DIM(5000)
     D UPA             S              1    DIM(5000)
     D AR              S              1    DIM(5000)
     D BLK             S              1    DIM(240)
     D OT              S              1    DIM(240) ASCEND
     D OTB             S              1    DIM(240)
     D OTP             S              1    DIM(240)
     D OTW             S              1    DIM(240)
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 BUG5670
      ** External DS for customer details                                                    BUG5670
                                                                                             BUG5670
     D DSSDY         E DS                  EXTNAME(DSSDY)                                    BUG5670
      ** Second DS for Access Programs, Long Data Structure                                  BUG5670
                                                                                             BUG5670
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D                 DS                                                                     239499
     D  ZOUT15                 1     15A                                                      239499
     D  ZFSIGN                16     16A                                                      239499
     D  ZSFLD                  1     16A                                                      239499
     D                 DS
     D  SRCDTA                 1     80
     D  S                      1     80
     D                                     DIM(80) ASCEND
      *
     D                 DS
     D  DATA                   1     41
     D  DAT                    1     41
     D                                     DIM(41)
 
     D PCNUM           S             10                                                      BUG5670
     D PCNST           S              7                                                      BUG5670
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Output File/Field Details if not found
 
     C     FLDDTP        CHAIN     SDAUFDD0                           80
     C     *IN80         IFEQ      '1'
     C                   EXSR      SRFilFldDet
     C                   ENDIF
 
     C                   Z-ADD     *ZERO         SEQN
     C                   Z-ADD     *ZERO         FLDN
 
      ** Display Screen until F3 - Exit
 
     C     *INKC         DOWEQ     '0'
     C                   EXSR      SRDisplay
     C                   ENDDO
 
      ** End Program and Exit
 
     C                   EXSR      SREnd
      /EJECT
      *****************************************************************
      * SRDisplay - Display screen                                    *
      *                                                               *
      * Called by : MAIN                                              *
      * Calls     : SRFilSubf, SREnd, SRDetNar, SRRolldown            *
      *****************************************************************
     C     SRDisplay     BEGSR
 
      ** Fill Subfile
     C                   EXSR      SRFilSubf
 
      ** Display Subfile
     C****************** WRITE     SUBFLCTL                                                   CAAA02
     C     RRN           IFEQ      0                                                         BUG2469
     C                   MOVEL     ERR(4)        DDERR                                       BUG2469
     C                   ENDIF                                                               BUG2469
                                                                                             BUG2469
     C                   WRITE     SUBMESS
     C     RRN           IFEQ      0                                                         BUG2469
     C                   EVAL      DESC = *Blanks                                            BUG2469
     C                   EVAL      DATA = *Blanks                                            BUG2469
     C                   MOVE      '0'           *IN05                                       BUG2469
     C                   Z-ADD     1             RRN               4 0    04                 BUG2469
     C                   WRITE     SUBFLREC                                                  BUG2469
     C                   ENDIF                                                               BUG2469
                                                                                             BUG2469
     C                   WRITE     SUBFLCTL                                                   CAAA02
     C                   READ      SUBFLCTL                               99
     C                   MOVEL     *BLANK        DDERR
 
      ** Check if record still exists
     C     DDKEY         CHAIN     SDAULGL0                           80
      *
      ** Send message 'Record no longer on file'
     C     *IN80         IFEQ      *ON
     C                   MOVE      'Y2U0009'     RTNCDE
     C                   MOVE      '1'           @INKL
     C                   EXSR      SREnd
     C                   ENDIF
 
      ** F3 - Exit function
     C     *INKC         IFEQ      '1'
     C                   MOVE      '1'           @INKC
     C                   EXSR      SREnd
     C                   ENDIF
 
      ** F6 - Before/After
     C     *INKF         IFEQ      '1'
     C                   ADD       1             SCRN
     C     SCRN          IFGT      3
     C                   Z-ADD     1             SCRN
     C                   ENDIF
     C                   Z-ADD     #SEQN         SEQN
     C                   Z-ADD     #FLDN         FLDN
     C                   ENDIF
      ** Determine if Insert, Delete or Before/After Narrative
     C                   EXSR      SRDetNar
 
      ** F7 - Window Left
     C     *INKG         IFEQ      '1'
     C     SCRN          IFEQ      1
     C                   SUB       20            OFFS
     C     OFFS          IFLT      0
     C                   Z-ADD     221           OFFS
     C                   ENDIF
     C                   ELSE
     C                   SUB       40            OFFS
     C     OFFS          IFLT      0
     C                   Z-ADD     201           OFFS
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD     #SEQN         SEQN
     C                   Z-ADD     #FLDN         FLDN
     C                   ENDIF
 
      ** F8 - Window Right
     C     *INKH         IFEQ      '1'
     C     SCRN          IFEQ      1
     C                   ADD       20            OFFS
     C     OFFS          IFGT      221
     C                   Z-ADD     1             OFFS
     C                   ENDIF
     C                   ELSE
     C                   ADD       40            OFFS
     C     OFFS          IFGT      201
     C                   Z-ADD     1             OFFS
     C                   ENDIF
     C                   ENDIF
     C                   Z-ADD     #SEQN         SEQN
     C                   Z-ADD     #FLDN         FLDN
     C                   ENDIF
 
      ** F9 - Authorise
     C     *INKI         IFEQ      '1'
     C                   MOVE      '1'           @INKI
     C                   EXSR      SREnd
     C                   ENDIF
 
      ** F10 - Delete
     C     *INKJ         IFEQ      '1'
     C                   MOVE      '1'           @INKJ
     C                   EXSR      SREnd
     C                   ENDIF
 
      ** F12 - Return to Previous screen
     C     *INKL         IFEQ      '1'
     C                   MOVE      '1'           @INKL
     C                   EXSR      SREnd
     C                   ENDIF
 
      ** Rolldown
     C     *IN05         IFEQ      '1'
     C                   EXSR      SRRolldown
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRFilSubf - Fill Subfile                                      *
      *                                                               *
      * Called by : SRDisplay                                         *
      * Calls     : SRMatchComp                                       *
      *****************************************************************
     C     SRFilSubf     BEGSR
 
     C                   MOVEA     '000'         *IN(1)
     C                   MOVEA     '1'           *IN(4)
     C                   MOVEA     '1'           *IN(89)                                     BUG5780
     C                   Z-ADD     *ZERO         RRN
     C                   WRITE     SUBFLCTL
     C     FLDDTK        SETLL     SDAUFDD0
     C     FLDDTP        READE     SDAUFDD0                               99
     C     RPGN          CHAIN     SDAUFSL0                           89                     BUG5780
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     SEQN          #SEQN             3 0
     C                   Z-ADD     FLDN          #FLDN             3 0
     C                   ELSE
     C                   Z-ADD     *ZERO         #SEQN
     C                   Z-ADD     *ZERO         #FLDN
     C                   Z-ADD     *ZERO         SEQN
     C                   Z-ADD     *ZERO         FLDN
     C     DDERR         IFEQ      *BLANK
     C                   MOVEL     ERR(1)        DDERR                          *END OF FILE
     C                   ENDIF
     C                   ENDIF
 
     C     *IN99         DOWEQ     '0'
 
      ** Match Data to field and Compare the Data
     C                   EXSR      SRMatchComp
 
      ** Output the Differences if action is Amend
     C     ENTT          IFEQ      'UB'
      *
     C     SCRN          IFEQ      1
     C                   MOVEA     OTB(OFFS)     DAT(1)
     C                   MOVEL     ' '           DAT(21)
     C                   MOVEA     OTP(OFFS)     DAT(22)
     C                   ELSE
     C     SCRN          IFEQ      2
     C                   MOVEA     OTB(OFFS)     DAT(1)
     C                   MOVEL     ' '           DAT(41)
     C                   ELSE
     C                   MOVEA     OTP(OFFS)     DAT(1)
     C                   MOVEL     ' '           DAT(41)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
 
      ** If Action is not Amend then Display all the fields
      ** except internal fields suppressed in file SDAUFSPD and specific fields              BUG5780
      ** switched off in client zone in the file SDAUFXPD.                                   BUG5780
     C     ALACTN        IFNE      'A'
     C     *IN89         ANDEQ     *ON                                                       BUG5780
     C                   ADD       1             RRN               4 0    04
     C                   WRITE     SUBFLREC
      *
      ** If Differences found then only Display the changed fields
      ** except internal fields suppressed in file SDAUFSPD and specific fields              BUG5780
      ** switched off in client zone in the file SDAUFXPD.                                   BUG5780
     C                   ELSE
     C     *IN20         IFEQ      '1'
     C     *IN89         ANDEQ     *ON                                                       BUG5780
     C                   ADD       1             RRN               4 0    04
     C                   WRITE     SUBFLREC
     C                   ENDIF
     C                   ENDIF
 
 B1  C     RRN           IFEQ      #C
     C     FLDDTP        READE     SDAUFDD0                               99
     C                   SETON                                        89                     BUG5780
     C     RPGN          CHAIN     SDAUFSL0                           89                     BUG5780
 B2  C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         SEQN
     C                   Z-ADD     *ZERO         FLDN
 B3  C     DDERR         IFEQ      *BLANK
     C                   MOVEL     ERR(1)        DDERR                          *END OF FILE
 E3  C                   ENDIF
      *
 X2  C                   ELSE
     C                   SETON                                            99
 E2  C                   ENDIF
      *
 X1  C                   ELSE
     C     FLDDTP        READE     SDAUFDD0                               99
     C                   SETON                                        89                     BUG5780
     C     RPGN          CHAIN     SDAUFSL0                           89                     BUG5780
      ** Suppress repetitive display of account details for RECOMD and REIACD.               BUG5780
     C     FILE          IFEQ      'ACCNTAB'                                                 BUG5780
     C     RPGN          IFEQ      'CNUM'                                                    BUG5780
     C     SEQN          ANDNE     002                                                       BUG5780
     C     RPGN          OREQ      'CCY'                                                     BUG5780
     C     SEQN          ANDNE     003                                                       BUG5780
     C     RPGN          OREQ      'ACSQ'                                                    BUG5780
     C     SEQN          ANDNE     005                                                       BUG5780
     C     RPGN          OREQ      'BRCA'                                                    BUG5780
     C     SEQN          ANDNE     007                                                       BUG5780
     C     RPGN          OREQ      'ACOD'                                                    BUG5780
     C     SEQN          ANDNE     128                                                       BUG5780
     C                   SETOFF                                       89                     BUG5780
     C                   ENDIF                                                               BUG5780
     C     RPGN          IFEQ      'DRBR'                                                    BUG5780
     C                   MOVEA     NARREP(2)     DESC                                        BUG5780
     C                   ENDIF                                                               BUG5780
     C     RPGN          IFEQ      'CRBR'                                                    BUG5780
     C                   MOVEA     NARREP(3)     DESC                                        BUG5780
     C                   ENDIF                                                               BUG5780
     C     RPGN          IFEQ      'CHBR'                                                    BUG5780
     C                   MOVEA     NARREP(4)     DESC                                        BUG5780
     C                   ENDIF                                                               BUG5780
     C     RPGN          IFEQ      'DACP'                                                    BUG5780
     C                   MOVEA     NARREP(5)     DESC                                        BUG5780
     C                   ENDIF                                                               BUG5780
     C     RPGN          IFEQ      'CACP'                                                    BUG5780
     C                   MOVEA     NARREP(6)     DESC                                        BUG5780
     C                   ENDIF                                                               BUG5780
     C     RPGN          IFEQ      'CHAC'                                                    BUG5780
     C                   MOVEA     NARREP(7)     DESC                                        BUG5780
     C                   ENDIF                                                               BUG5780
     C     RPGN          IFEQ      'IACE'                                                    BUG5780
     C                   MOVEA     NARREP(8)     DESC                                        BUG5780
     C                   ENDIF                                                               BUG5780
     C     RPGN          IFEQ      'CMBE'                                                    BUG5780
     C                   MOVE      '   '         DESC                                        BUG5780
     C                   ENDIF                                                               BUG5780
     C     RPGN          IFEQ      'CHDBE'                                                   BUG5780
     C                   MOVE      ' '           DESC                                        BUG5780
     C                   ENDIF                                                               BUG5780
     C                   ENDIF                                                               BUG5780
      ** For SDCURRPD correct text retrieved from SDAUFDPD as it is prohibitive to correct   BUG5780
      ** the file field descriptions. We would need to redeliver zonal and global currency   BUG5780
      ** files and rebuild 72 global views and 21 zonal views in each zone.                  BUG5780
     C     FILE          IFEQ      'SDCURRPD'                                                BUG5780
     C     RPGN          IFEQ      'A6TAC5'                                                  BUG5780
     C                   MOVE      '5       '    DESC                                        BUG5780
     C                   ENDIF                                                               BUG5780
     C     RPGN          IFEQ      'A6IRDP'                                                  BUG5780
     C                   MOVE      'Plcs'        DESC                                        BUG5780
     C                   ENDIF                                                               BUG5780
     C     RPGN          IFEQ      'A6BODS'                                                  BUG5780
     C                   MOVE      'Ovr'         DESC                                        BUG5780
     C                   ENDIF                                                               BUG5780
     C     RPGN          IFEQ      'A6FRDS'                                                  BUG5780
     C     RPGN          OREQ      'A6LEDS'                                                  BUG5780
     C                   MOVE      'Ovr  '       DESC                                        BUG5780
     C                   ENDIF                                                               BUG5780
     C     RPGN          IFEQ      'A6SWDT'                                                  BUG5780
     C                   MOVEA     NARREP(1)     DESC                                        BUG5780
     C                   ENDIF                                                               BUG5780
     C     RPGN          IFEQ      'A6MACD'                                                  BUG5780
     C     RPGN          OREQ      'A6MICD'                                                  BUG5780
     C                   MOVE      'ion    '     DESC                                        BUG5780
     C                   ENDIF                                                               BUG5780
     C     RPGN          IFEQ      'A6CMSC'                                                   CMG003
     C                   MOVEA     NARREP(9)     DESC                                         CMG003
     C                   ENDIF                                                                CMG003
     C     RPGN          IFEQ      'A6CMLT'                                                   CMG003
     C                   MOVEA     NARREP(10)    DESC                                         CMG003
     C                   ENDIF                                                                CMG003
     C                   ENDIF                                                               BUG5780
      *                                                                                      BUG5780
     C     FILE          IFEQ      'CGCORRPD'                                                BUG5780
     C     RPGN          IFEQ      'CDCUST'                                                  BUG5780
     C     RPGN          OREQ      'CDATDT'                                                  BUG5780
     C     RPGN          OREQ      'CDDADT'                                                  BUG5780
     C                   MOVE      '       '     DESC                                        BUG5780
     C                   ENDIF                                                               BUG5780
     C     RPGN          IFEQ      'CDBICC'                                                  BUG5780
     C                   MOVE      ' & Loc)     'DESC                                        BUG5780
     C                   ENDIF                                                               BUG5780
     C                   ENDIF                                                               BUG5780
      *                                                                                      BUG5780
 B2  C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         SEQN
     C                   Z-ADD     *ZERO         FLDN
 B3  C     DDERR         IFEQ      *BLANK
     C                   MOVEL     ERR(1)        DDERR                          *END OF FILE
 E3  C                   ENDIF
 E2  C                   ENDIF
 E1  C                   ENDIF
 
     C                   ENDDO
 
     C     *IN(4)        IFEQ      '1'
     C                   MOVEA     '010'         *IN(1)
     C                   ELSE
     C                   MOVEA     '111'         *IN(1)
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRRolldown - Rolldown Subfile                                 *
      *                                                               *
      * Called by : SRDisplay                                         *
      * Calls     : SRMatchComp                                       *
      *****************************************************************
     C     SRRolldown    BEGSR
 
     C                   Z-ADD     *ZERO         RRN
     C                   Z-ADD     #SEQN         SEQN
     C                   Z-ADD     #FLDN         FLDN
     C     FLDDTK        SETGT     SDAUFDD0
     C     FLDDTP        READPE    SDAUFDD0                               99    *
      *
     C     *IN99         DOWEQ     '0'
     C     RRN           ANDLT     #C
     C     FLDDTP        READPE    SDAUFDD0                               99
      *
      ** If Action is not Amend then Read back all the fields
     C     ALACTN        IFNE      'A'
     C                   ADD       1             RRN
      *
      ** If Differences found only Read back the changed fields
     C                   ELSE
     C                   EXSR      SRMatchComp
     C     *IN20         IFEQ      '1'
     C                   ADD       1             RRN
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
 
     C     *IN99         IFEQ      '1'
     C                   Z-ADD     *ZERO         SEQN
     C                   Z-ADD     *ZERO         FLDN
     C                   MOVEL     ERR(2)        DDERR                          *START OF FILE
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRMatchComp - Match Data to field and Compare the Data        *
      *                                                               *
      * Called by : SRFilSubf, SRRolldown                             *
      * Calls     : SRMatchData, SRFldCnvRqd                          *
      *****************************************************************
     C     SRMatchComp   BEGSR
 
      ** UBA - Match Data to Field for first record
 
     C                   MOVEA     UBA           AR
     C                   EXSR      SRMatchData
      ** Check if field conversion is required
     C                   EXSR      SRFldCnvRqd
     C                   MOVEA     OT            OTB
 
      ** If not Amend mode, output first record
 
 B1  C     ENTT          IFNE      'UB'
     C                   MOVEA     OTB(OFFS)     DAT(1)
     C                   MOVEL     ' '           DAT(41)
 
      ** UPA - Match Data to Field for second record
 
 X1  C                   ELSE
     C                   MOVEA     UPA           AR
     C                   EXSR      SRMatchData
      ** Check if field conversion is required
     C                   EXSR      SRFldCnvRqd
     C                   MOVEA     OT            OTP
      *
      ** Compare Data for both records and Set on *IN20 if different
     C                   MOVE      '0'           *IN20
     C                   Z-ADD     1             X                 3 0
     C     X             DOUGT     240
     C     OTB(X)        IFNE      OTP(X)
     C                   MOVE      '1'           *IN20
     C                   MOVE      '<'           DESC
     C                   Z-ADD     241           X
      *
     C                   ELSE
     C                   ADD       1             X
     C                   ENDIF
     C                   ENDDO
 
 E1  C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRMatchData -  Match Data to Field                            *
      *                                                               *
      * Called by : SRMatchComp                                       *
      * Calls     : SRCvtPack, SRCvtSign                              *
      *****************************************************************
     C     SRMatchData   BEGSR
 
     C                   Z-ADD     1             Z                 4 0
     C                   MOVEL     *BLANK        OT
     C                   Z-ADD     BUF           SAVBUF            4 0
 
      ** Alpha Field
 
     C     TYP           IFEQ      'A'
     C                   MOVEA     AR(BUF)       OT(Z)
     C                   ADD       LEN           Z
     C                   ENDIF
 
      ** Packed Field
 
     C     TYP           IFEQ      'P'
     C                   Z-ADD     *ZERO         CNT               1 0
     C                   Z-ADD     *ZERO         Y                 4 0          * No of DIGS Proc
      *
     C     Y             DOWLT     DIG
     C                   MOVEA     AR(BUF)       FLD               1
     C                   EXSR      SRCvtPack
     C                   MOVE      FLD1          OT(Z)
     C                   ADD       1             Z
     C                   ADD       1             Y
      *
     C     Y             IFLT      DIG
     C                   MOVE      FLD2          OT(Z)
     C                   ADD       1             Z
     C                   ADD       1             Y
     C                   ELSE
     C                   SUB       1             Z
     C     OT(Z)         IFEQ      *BLANK
     C                   MOVEL     '0'           OT(Z)
     C                   ENDIF
     C                   ADD       1             Z
     C                   MOVEL     SIGN          OT(Z)
     C                   ADD       1             Z
     C                   ENDIF
      *
     C                   ADD       1             BUF
     C                   ENDDO
      *
     C                   ENDIF
 
      ** Signed Field
 
     C     TYP           IFEQ      'S'
     C                   Z-ADD     *ZERO         CNT               1 0
     C                   Z-ADD     *ZERO         Y                 4 0          * Field Length
      *
     C     Y             DOWLT     LEN
     C                   MOVEA     AR(BUF)       FLD               1
     C                   EXSR      SRCvtSign
     C                   MOVE      FLD2          OT(Z)
     C                   ADD       1             Z
     C                   ADD       1             Y
      *
     C     Y             IFEQ      LEN
     C                   SUB       1             Z
     C     OT(Z)         IFEQ      *BLANK
     C                   MOVEL     '0'           OT(Z)
     C                   ENDIF
     C                   ADD       1             Z
     C                   MOVEL     SIGN          OT(Z)
     C                   ADD       1             Z
     C                   ENDIF
      *
     C                   ADD       1             BUF
     C                   ENDDO
      *
     C                   ENDIF
 
     C     Z             IFLE      240
     C                   MOVEA     BLK           OT(Z)
     C                   ENDIF
 
     C                   Z-ADD     SAVBUF        BUF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRCvtPack - Convert Packed Field                              *
      *                                                               *
      * Called by : SRMatchData                                       *
      * Calls     : SRBitset                                          *
      *****************************************************************
     C     SRCvtPack     BEGSR
 
      ** Set Bits
 
     C                   EXSR      SRBitset
 
     C     CHCK1         IFLE      9
     C                   MOVEL     FLD1N         FLD1              1
     C                   ELSE
     C                   MOVEL     '*'           FLD1
     C                   ENDIF
      *
     C     CHCK2         IFLE      9
     C                   MOVEL     *BLANK        SIGN              1
     C                   MOVEL     FLD2N         FLD2              1
     C                   ELSE
     C                   MOVEL     '*'           FLD2
     C     CHCK2         IFEQ      15
     C                   MOVEL     *BLANK        SIGN
     C                   ELSE
     C                   MOVEL     '-'           SIGN
     C                   ENDIF
     C                   ENDIF
 
     C     FLD1          IFEQ      '0'
     C     CNT           ANDEQ     *ZERO
     C                   MOVEL     *BLANK        FLD1
     C                   ELSE
     C                   Z-ADD     1             CNT
     C                   ENDIF
      *
     C     FLD2          IFEQ      '0'
     C     CNT           ANDEQ     *ZERO
     C                   MOVEL     *BLANK        FLD2
     C                   ELSE
     C                   Z-ADD     1             CNT
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRCvtSign - Convert Signed Field                              *
      *                                                               *
      * Called by : SRMatchData                                       *
      * Calls     : SRBitset                                          *
      *****************************************************************
     C     SRCvtSign     BEGSR
 
     C                   EXSR      SRBitset
      *
     C     CHCK1         IFEQ      15
     C                   MOVEL     *BLANK        SIGN
     C                   ELSE
     C                   MOVEL     '-'           SIGN
     C                   ENDIF
      *
     C     CHCK2         IFLE      9
     C                   MOVEL     FLD2N         FLD2              1
     C                   ELSE
     C                   MOVEL     '*'           FLD2
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRBitset - Set Bit                                            *
      *                                                               *
      * Called by : SRCvtPack, SRCvtSign                              *
      * Calls     :                                                   *
      *****************************************************************
     C     SRBitset      BEGSR
 
     C                   Z-ADD     *ZERO         FLD1N
     C                   Z-ADD     *ZERO         CHCK1
     C                   Z-ADD     *ZERO         FLD2N
     C                   Z-ADD     *ZERO         CHCK2
 
     C                   TESTB     '0'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       8             FLD1N             1 0
     C                   ADD       8             CHCK1             2 0
     C                   ENDIF
 
     C                   TESTB     '1'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       4             FLD1N
     C                   ADD       4             CHCK1
     C                   ENDIF
 
     C                   TESTB     '2'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       2             FLD1N
     C                   ADD       2             CHCK1
     C                   ENDIF
 
     C                   TESTB     '3'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       1             FLD1N
     C                   ADD       1             CHCK1
     C                   ENDIF
 
     C                   TESTB     '4'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       8             FLD2N             1 0
     C                   ADD       8             CHCK2             2 0
     C                   ENDIF
 
     C                   TESTB     '5'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       4             FLD2N
     C                   ADD       4             CHCK2
     C                   ENDIF
 
     C                   TESTB     '6'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       2             FLD2N
     C                   ADD       2             CHCK2
     C                   ENDIF
 
     C                   TESTB     '7'           FLD                      30
     C     *IN30         IFEQ      '1'
     C                   ADD       1             FLD2N
     C                   ADD       1             CHCK2
     C                   ENDIF
 
     C                   Z-ADD     1             BS                2 0
     C     CHCK1         LOOKUP    BIT(BS)                                99
     C                   MOVEL     ALP(BS)       FLD1A             1
     C                   Z-ADD     1             BS
     C     CHCK2         LOOKUP    BIT(BS)                                99
     C                   MOVEL     ALP(BS)       FLD2A             1
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SRFldCnvRqd - Check if conversion of the field is required.  *
      *              - If the field is a Date field then convert to   *
      *                ddmmyy format before output to screen.         *
      *              - If the field is a Numeric then insert the No.  *
      *                of Decimal places before output to screen.     *
      *              - Accounts fields GLBT and RETB are stored as    *
      *                BIT settings which need to be converted.       *
      *                                                               *
      *  Called by : SRMatchComp                                      *
      *  Calls     : ZDATE2, ZALIGN, ZEDIT                            *
      *****************************************************************
     C     SRFldCnvRqd   BEGSR
 
     C     RPGN          CHAIN     SDAUFCPD                           80
      *
 B1  C     *IN80         IFEQ      *OFF
 
      ** Field is a Date
 
     C     ALFTYP        IFEQ      'D'
     C                   MOVEA     OT            WDAYN             5
     C                   MOVE      WDAYN         ZDAYNO
 
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    DATEB             7
 
     C                   MOVE      ZDATE         WDATE             6
     C                   MOVEA     WDATE         OT
     C                   ENDIF
 
      ** Field is a Numeric
 
     C     ALFTYP        IFEQ      'N'
     C                   MOVEA     OT            ZFIELD
     C     '-'           SCAN      ZFIELD:1                                                   239499
     C                   IF        %FOUND                                                     239499
     C                   MOVE      ZFIELD        ZFLD17                                       239499
     C                   CALLB     'ZASIGN'                                                   239499
     C                   PARM                    ZAsignOk          1                          239499
     C                   PARM                    ZFLD17           17                          239499
     C                   PARM      DIG           ZSDIG             2 0                        239499
     C                   PARM      0             ZSDEC             1 0                        239499
     C                   PARM                    ZSDCSP            1                          239499
     C                   PARM                    ZOUT15                                       239499
     C                   PARM                    ZFSIGN                                       239499
      *                                                                                       239499
     C                   MOVE      ZSFLD         ZFIELD                                       239499
     C                   ADD       1             DEC                                          239499
      *                                                                                       239499
     C                   ELSE                                                                 239499
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      DIG           ZADIG             2 0
     C                   ENDIF                                                                239499
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      DEC           ZADEC
      *
     C                   MOVEA     ZFIELD        OT
     C                   ENDIF
      *
 E1  C                   ENDIF
 
      ** Convert Account field GLBT and RETB to Screen field values
 
 B1  C     FILE          IFEQ      'ACCNTAB'
 
 B2  C     RPGN          IFEQ      'GLBT'
     C                   EVAL      DESC = *Blanks
     C                   EVAL      DESC = 'Print address Y/N'
      *
     C                   MOVEA     OT            GLBT              1
     C                   TESTB     '2'           GLBT                     21
     C                   IF        *IN21
     C                   MOVEA     'Y'           OT
     C                   ELSE
     C                   MOVEA     'N'           OT
     C                   ENDIF
      *
 E2  C                   ENDIF
 
 B2  C                   IF        RPGN = 'RETB' AND
     C                             DESC = 'Refer all debits'
      *
     C                   MOVEA     OT            RETB              1
     C                   TESTB     '0'           RETB                     21
     C                   IF        *IN21
     C                   MOVEA     'Y'           OT
     C                   ELSE
     C                   MOVEA     'N'           OT
     C                   ENDIF
      *
 E2  C                   ENDIF
 
 B2  C                   IF        RPGN = 'RETB' AND
     C                             DESC = 'Refer all credits'
      *
     C                   MOVEA     OT            RETB
     C                   TESTB     '1'           RETB                     21
     C                   IF        *IN21
     C                   MOVEA     'Y'           OT
     C                   ELSE
     C                   MOVEA     'N'           OT
     C                   ENDIF
      *
 E2  C                   ENDIF
 
 B2  C                   IF        RPGN = 'RETB' AND
     C                             DESC = 'Block all debits'
      *
     C                   MOVEA     OT            RETB
     C                   TESTB     '2'           RETB                     21
     C                   IF        *IN21
     C                   MOVEA     'Y'           OT
     C                   ELSE
     C                   MOVEA     'N'           OT
     C                   ENDIF
      *
 E2  C                   ENDIF
 
 B2  C                   IF        RPGN = 'RETB' AND
     C                             DESC = 'Block all credits'
      *
     C                   MOVEA     OT            RETB
     C                   TESTB     '3'           RETB                     21
     C                   IF        *IN21
     C                   MOVEA     'Y'           OT
     C                   ELSE
     C                   MOVEA     'N'           OT
     C                   ENDIF
      *
 E2  C                   ENDIF
 
 B2  C                   IF        RPGN = 'RETB' AND
     C                             DESC = 'Inactive Account Y/N'
      *
     C                   MOVEA     OT            RETB
     C                   TESTB     '4'           RETB                     21
     C                   IF        *IN21
     C                   MOVEA     'Y'           OT
     C                   ELSE
     C                   MOVEA     'N'           OT
     C                   ENDIF
      *
 E2  C                   ENDIF
 
 B2  C                   IF        RPGN = 'RETB' AND
     C                             DESC = 'Bankrupt/liquidated Y/N'
      *
     C                   MOVEA     OT            RETB
     C                   TESTB     '6'           RETB                     21
     C                   IF        *IN21
     C                   MOVEA     'Y'           OT
     C                   ELSE
     C                   MOVEA     'N'           OT
     C                   ENDIF
      *
 E2  C                   ENDIF
 
 B2  C                   IF        RPGN = 'RETB' AND
     C                             DESC = 'Bad Debt Y/N'
      *
     C                   MOVEA     OT            RETB
     C                   TESTB     '7'           RETB                     21
     C                   IF        *IN21
     C                   MOVEA     'Y'           OT
     C                   ELSE
     C                   MOVEA     'N'           OT
     C                   ENDIF
      *
 E2  C                   ENDIF
 
 E1  C                   ENDIF
 
     C                   IF        FILE = 'SDEXSTPD'                                         BUG5670
                                                                                             BUG5670
     C                   IF        RPGN = 'BYROBN' or RPGN = 'BYPOBN'                        BUG5670
     C                             or RPGN = 'BYROCS' or RPGN = 'BYPOCS'                     BUG5670
     C                             or RPGN = 'BYRIBN' or RPGN = 'BYPIBN'                     BUG5670
     C                             or RPGN = 'BYRCNO' or RPGN = 'BYRCNB'                     BUG5670
     C                             or RPGN = 'BYBYNB' or RPGN = 'BYACBN'                     BUG5670
                                                                                             BUG5670
     C                   MOVEA     OT            PCNUM                                       BUG5670
      *                                                                                      BUG7323
      ** Test numeric. Value can be a counter party nostro that does not exist as CNUM       BUG7323
      ** This will be in short name format so just display.                                  BUG7323
     C                   MOVEL     PCNUM         #LNUM             6                         BUG7323
     C                   TESTN                   #LNUM                99                     BUG7323
     C*******************IF        PCNUM <> *BLANKS                                   BUG5670BUG7323
     C                   IF        PCNUM <> *BLANKS and *IN99 = *ON                          BUG7323
                                                                                             BUG5670
      ** Access Customer details                                                             BUG5670
                                                                                             BUG5670
     C                   CALLB     'AOCUSTR0'                                                BUG5670
     C                   PARM      *BLANKS       PRTCD                                       BUG5670
     C                   PARM      '*KEY   '     POPTN                                       BUG5670
     C                   PARM                    PCNUM                                       BUG5670
     C                   PARM                    PCNST                                       BUG5670
     C     SDCUST        PARM      SDCUST        DSSDY                                       BUG5670
                                                                                             BUG5670
      ** Database error                                                                      BUG5670
                                                                                             BUG5670
     C                   IF        PRTCD <> *BLANKS                                          BUG5670
     C                   EVAL      DBFILE = 'SDCUSTPD'                                       BUG5670
     C                   EVAL      DBASE = 3                                                 BUG5670
     C                   EVAL      DBKEY = PCNUM                                             BUG5670
     C                   EXSR      *PSSR                                                     BUG5670
     C                   ELSE                                                                BUG5670
     C                   MOVEA     BBCSSN        OT                                          BUG5670
     C                   ENDIF                                                               BUG5670
     C                   ENDIF                                                               BUG5670
                                                                                             BUG5670
     C                   ENDIF                                                               BUG5670
                                                                                             BUG5670
     C                   ENDIF                                                               BUG5670
                                                                                             BUG5670
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRFilFldDet - Output File and Field Details                   *
      *                                                               *
      * Called by : MAIN                                              *
      * Calls     : QCMDEXC, SRAccFld                                 *
      *****************************************************************
     C     SRFilFldDet   BEGSR
 
      ** Output field details for main file to file FFD
 
     C                   Z-ADD     59            MESLEN           15 5
     C                   MOVEA     FILE          MMF(13)
      *
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    MMF
     C                   PARM                    MESLEN
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        NARR1
     C                   MOVEL     *BLANK        NARR2
     C                   MOVEL     ERR(3)        DDERR
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Output field details for any extension files to file FFD
 
     C     FLDDTP        SETLL     SDAUEFPD
     C     FLDDTP        READE     SDAUEFPD                               80
      *
     C     *IN80         DOWEQ     '0'
 
     C                   Z-ADD     79            MESLEN           15 5
     C                   MOVEA     ALEFIL        MEF(13)
      *
     C                   CALL      'QCMDEXC'                            9999
     C                   PARM                    MEF
     C                   PARM                    MESLEN
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     *BLANK        NARR1
     C                   MOVEL     *BLANK        NARR2
     C                   MOVEL     ERR(2)        DDERR
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     FLDDTP        READE     SDAUEFPD                               80
     C                   ENDDO
 
      ** Write field details from file FFD to file SDAUFDPD
 
     C                   OPEN      FFD
      *
     C                   Z-ADD     1             FLDN
     C                   Z-ADD     1             BUF
     C                   READ      FFD                                    99
      *
     C     *IN99         DOWEQ     '0'
     C                   MOVEL     WHFLDI        RPGN
     C                   Z-ADD     WHFLDB        LEN
     C                   Z-ADD     WHFLDD        DIG
     C                   Z-ADD     WHFLDP        DEC
     C                   MOVEL     WHFTXT        DESC
     C                   MOVEL     WHFLDT        TYP
     C                   Z-ADD     FLDN          SEQN
      *
      ** For Accounts field RETB expand it's BIT settings to the
      ** 7 screen fields.
     C     FILE          IFEQ      'ACCNTAB'
     C     RPGN          ANDEQ     'RETB'
     C                   EXSR      SRAccFld
      *
     C                   ELSE
     C                   WRITE     SDAUFDD0
     C                   ADD       1             FLDN
     C                   ENDIF
      *
     C                   READ      FFD                                    99
     C                   ADD       LEN           BUF
     C                   ENDDO
      *
     C                   CLOSE     FFD
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRAccFld - In Accounts Maintenance field RETB holds the value *
      *            of 7 screen fields via BIT settings. To enable the *
      *            user to see what has changed we need to expand the *
      *            field to its 7 screen fields.                      *
      *                                                               *
      * Called by : SRFilFldDet                                       *
      * Calls     :                                                   *
      *****************************************************************
     C     SRAccFld      BEGSR
 
     C                   Z-ADD     1             W                 2 0
 
     C                   DO        7
     C                   MOVEL     WHFLDI        RPGN
     C                   Z-ADD     WHFLDB        LEN
     C                   Z-ADD     WHFLDD        DIG
     C                   Z-ADD     WHFLDP        DEC
     C                   MOVEA     RETBD(W)      DESC
     C                   MOVEL     WHFLDT        TYP
     C                   Z-ADD     FLDN          SEQN
      *
     C                   WRITE     SDAUFDD0
     C                   ADD       1             FLDN
     C                   ADD       1             W
     C                   ENDDO
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRDetNar - Determine if Insert, Delete or Before/After        *
      *            Narrative.                                         *
      *                                                               *
      * Called by : *INZSR, SRDisplay                                 *
      * Calls     :                                                   *
      *****************************************************************
     C     SRDetNar      BEGSR
 
     C                   MOVEL     *BLANK        NARR1
     C                   MOVEL     *BLANK        NARR2
     C     ENTT          IFEQ      'PT'
     C                   MOVEL     'INSERT'      NARR1
     C                   ENDIF
     C     ENTT          IFEQ      'UB'
     C     SCRN          IFEQ      1
     C                   MOVEL     'BEFORE'      NARR1
     C                   MOVEL     'AFTER'       NARR2
     C                   ENDIF
     C     SCRN          IFEQ      2
     C                   MOVEL     'BEFORE'      NARR1
     C                   ENDIF
     C     SCRN          IFEQ      3
     C                   MOVEL     'AFTER'       NARR1
     C                   ENDIF
     C                   ENDIF
     C     ENTT          IFEQ      'DL'
     C                   MOVEL     'DELETE'      NARR1
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *  SREnd - End Program                                          *
      *                                                               *
      *  Called by : Main Processing, SRPROC, *PSSR                   *
      *  Calls     :                                                  *
      *****************************************************************
     C     SREnd         BEGSR
 
      ** End Program and Return
     C                   SETON                                        LR
     C                   RETURN
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called By : Main Processing                                  *
      *  Calls     : AOBANKR0                                         *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Define Key Lists
     C     FLDDTK        KLIST
     C                   KFLD                    FILE
     C                   KFLD                    SEQN
     C                   KFLD                    FLDN
      *
     C     FLDDTP        KLIST
     C                   KFLD                    FILE
 
      ** Set up copyright parameter
     C                   MOVEA     CPY@          CPY2@            80
 
      ** Receive Parameter List
     C     *ENTRY        PLIST
     C                   PARM                    RTNCDE            7
     C                   PARM                    FILE
     C                   PARM                    UBA
     C                   PARM                    UPA
     C**********         PARM                    PKEY             20                          CGL029
     C                   PARM                    PKEY             26                          CGL029
     C                   PARM                    PACTN             1
      ** Command Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKI             1
     C                   PARM                    @INKJ             1
     C                   PARM                    @INKL             1
 
      ** Initialise LDA field
     C                   MOVEL     'SDAUTHCMP'   DBPGM
 
      ** Access Bank details via access program
     C                   CALL      'AOBANKR0'
     C                   PARM      '       '     PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     1             DBASE                          *************
     C                   MOVEL     'SDBANKPD'    DBFILE                         *DB ERROR 01*
     C                   MOVEL     POPTN         DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check System Date Format, DDMMYY (*IN98 off)
      *                            MMDDYY (*IN98 on).
 
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
 
      ** Access Authorisation log
     C     PKEY          CHAIN     SDAULGL0                           80
      *
     C     *IN80         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE                          *************
     C                   MOVEL     'SDAULGPD'    DBFILE                         *DB ERROR 02*
     C                   MOVEL     PKEY          DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise display fields
     C                   TIME                    DDTIME
     C                   MOVE      PSUSER        DDUSR
     C                   MOVE      PSJOBNAME     DDWID
      *
     C                   MOVE      ALFUNC        DDFUNC
     C                   MOVE      ALKEY         DDKEY
     C                   MOVE      ALACTN        DDACTN
     C                   MOVE      ALUSER        DDUSER
      *
     C                   Z-ADD     12            #C                2 0
     C                   BITOFF    '01234567'    HI                1            *FOR HI INTNSTY
     C                   BITON     '267'         HI
     C                   MOVEL     HI            ERR
     C                   Z-ADD     1             SCRN              1 0
     C                   Z-ADD     1             OFFS              3 0
 
      ** Initialise display fields and indicators according
      ** to action and selection.
     C     PACTN         IFEQ      'X'
     C                   MOVE      *ON           *IN50
     C                   ELSE
     C     PACTN         IFEQ      'D'
     C                   MOVE      *ON           *IN51
     C                   ENDIF
     C                   ENDIF
      *
     C                   SELECT
     C     ALACTN        WHENEQ    'A'
     C                   MOVE      'UB'          ENTT              2
     C                   MOVE      *ON           *IN52
     C     ALACTN        WHENEQ    'I'
     C                   MOVE      'PT'          ENTT
     C     ALACTN        WHENEQ    'D'
     C                   MOVE      'DL'          ENTT
     C                   ENDSL
      *
      ** Determine if Insert, Delete or Before/After Narrative
     C                   EXSR      SRDetNar
 
     C                   ENDSR
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
** ERR
 END OF FILE
 START OF FILE
 ERROR - FILE NOT IN LIBRARY LIST, OR NOT AUTHORIZED TO FILE
 NO DIFFERENCE IN DETAILS AFTER AMENDMENT                                                    BUG2469
** MMF
DSPFFD FILE(          ) OUTPUT(*OUTFILE) OUTFILE(QTEMP/FFD)
** MEF
DSPFFD FILE(          ) OUTPUT(*OUTFILE) OUTFILE(QTEMP/FFD) OUTMBR(*FIRST *ADD)
** BIT
00010203040506070809101112131415
** ALP
0123456789ABCDEF
** RETBD
Refer all debits
Refer all credits
Block all debits
Block all credits
Inactive Account Y/N
Bankrupt/liquidated Y/N
Bad Debt Y/N
** NARREP                                                                                    BUG5780
SWIFT Dec. Plac. Active Date                                                                 BUG5780
Alt. Branch to post DR Int.                                                                  BUG5780
Alt. Branch to post CR Int.                                                                  BUG5780
Alt. Branch to post Charges                                                                  BUG5780
Alt. A/C to post Debit Int.                                                                  BUG5780
Alt. A/C to post Credit Int.                                                                 BUG5780
Alt. A/C to post Charges                                                                     BUG5780
Inactive Account Commission                                                                  BUG5780
ISO Currency Code                                                                             CMG003
Commodity Action Type                                                                         CMG003
