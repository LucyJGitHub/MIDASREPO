     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      **********************************************************************
/*STD *  RPGBASEMOD                                                        *
      **********************************************************************
      *                                                                    *
      *  Midas - Securities Trading Module                                 *
      *                                                                    *
      *  XX118003 - On-Line Positions Generation batch                     *
      *                                                                    *
      *  Function:  This module provides the batch job submitted by        *
      *             the user selection input in XX118001                   *
      *             It is part of the switchable feature HUT118, the CLP   *
      *             is doing the check                                     *
      *                                                                    *
      *  Called By: XXC118003 - Position Settlement Generated Report       *
      *                                                                    *
      *  (c) Finastra International Limited 2020                           *
      *                                                                    *
      *  Last Amend No. HUT118  *CREATE    Date 27May04                    *
      *                                                                    *
      *--------------------------------------------------------------------*
      *                                                                    *
      *  HUT118 - Position Settlements Online Generation                   *
      *                                                                    *
      **********************************************************************
      *                                                                    *
      *  Use of indicators.                                                *
      *                                                                    *
      **********************************************************************
      *                                                                    *
      *  S U B R O U T I N E  I N D E X                                    *
      *                                                                    *
      * SRProc   - Read file and process details                           *
      * SRSecDia - Security Diary file: extraction                         *
      * SRCorAct - Corporate Actions file: extraction                      *
      * SREarRed - Early Redemption file: extraction                       *
      * SRCliDep - Client Depots file: extraction                          *
      * *PSSR    - Error processing                                        *
      * *INZSR   - Initialisation routine                                  *
      *                                                                    *
      **********************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Security Diary events
     FSEDEVL3   IF   E           K DISK    INFSR(*PSSR)

      ** Security Diary events - Start of Day
     FXXSBSDV0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEDEVDF:SEDEVD1)
     F                                     PREFIX(S_)

      ** Client Depot Positions - Regeneration
     Fsecdepl8  IF   E           K DISK    INFSR(*PSSR)

      ** User Depot Positions - Regeneration
     FXXCOUPV1  IF   E           K DISK    INFSR(*PSSR)

      ** User Depot Positions - Regeneration
     FXXCDUDV0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(XXCDUDP0:XXCDUDP1)

      ** User Depot Positions - Regeneration
     FXXCDUDV1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(XXCDUDP0:XXCDUDP2)

      ** Position Sett RE-Generation - Diary Events
     FXXPSDEPP  O    E             DISK    INFSR(*PSSR) COMMIT

      ** Customer/Depot Position - Regeneration
     FXXCDUDPP  O    E             DISK    INFSR(*PSSR) COMMIT

      *********************************************************************
      /EJECT
      *********************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Parameters for module AOBANKR0
     D PRtCd           S              7A
     D Wmode           S              1A
     D POptn           S              7A

      ** Entry parameters
     D WCORF           S              6A
     D WERRF           S              6A
     D WSECU           S             10A
     D WEDTE           S              5A
     D WEDTN           S              5  0
     D WPDTE           S              5A
     D WPDTN           S              5  0
     D WEVTP           S              2A

      ** TMP variables
     D WDltCtr         S              5  0
     D WRun            S              1
     D WSec            S             10
     D WDTE            S              5  0
     D WEvt            S              2
     D WCor            S              6

      *********************************************************************
      /EJECT
      *********************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************

      ** Process inputs.
     C                   EXSR      SRProc

     C                   EVAL      *inLR = *ON

      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      *  SRProc - Read file and process details                           *
      *                                                                   *
      *********************************************************************
     C     SRProc        BEGSR

      *
      ** Extraction section
      *

      ** Security Diary file: DV events
     C                   if        WEVTP = 'DV'
     C                   exsr      SRSecDia
     C                   endif

      ** Client Depots file: DV events
     C                   if        WEVTP = 'DV'
     C                   exsr      SRCliDep
     C                   endif

     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRSecDia - Security Diary file: extraction                        *
      *                                                                   *
      * Called by: SRProc                                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRSecDia      BEGSR

     C     *loval        setll     SEDEVL3                            9999
     C  N99              read      SEDEVL3                              9999

B0   C                   dow       *in99 = *OFF
B1   C                   if        RECI = 'D'

      * input/modified today, check if already processed
B1   C                   if        LCD = BJRDNB and (CHTP = 'I' or CHTP = 'A')

     C     w0key1        chain     XXSBSDV0                           9898

      * not found, it must not have been already processed
B2   C                   if        *in98 = *on

      * if not all or selection, skip it
B3   C                   if        WSECU <> SDSN
X3   C                   else
      * if event match or not in selection, skip it
B4   C                   if        WEVTP <> 'DV'
X4   C                   else
      * if future event or not matched, skip it
B5   C                   if        (WEDTE = '00000' and SDED > BJRDNB) or
B5   C                             (WEDTE <> '00000' and WEDTN <> SDED)
X5   C                   else
      * if future event or not matched, skip it
B6   C                   if        (WPDTE = '00000' and SDPD > BJRDNB) or
B6   C                             (WPDTE <> '00000' and WPDTN <> SDPD)
X6   C                   else

     C                   write     XXPSDEP0

     C                   eval      WDte = *zeros

B7   C                   if        SDET = 'DV'
     C                   eval      WDte = SDPD
E7   C                   endif
      *
E6   C                   endif

E5   C                   endif
E4   C                   endif
E3   C                   endif
E2   C                   endif

E1   C                   endif
E1   C                   endif

     C                   read      SEDEVL3                              9999

E0   C                   enddo

     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * SRCliDep - Client Depots file: extraction                         *
      *                                                                   *
      * Called by: SRProc                                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     SRCliDep      BEGSR

      *
      * Extract from CDEPPD: Customer
      *

     C     *loval        setll     secdepl8                           9999
     C  N99              read      secdepl8                             9999

B00  C                   dow       *in99 = *OFF

B00  C                   if        DDTE <= BJRDNB

     C                   move      CDSN          CSSC
     C                   move      CDCN          CSCN
     C                   move      CDPA          CSBA
     C                   move      DDTE          CSDA

     C     w0key3        chain     XXCDUDV1                           9797

B00  C                   if        *in97 = *on

      * Set extraction fields
     C                   move      RECI          CDRECI
     C                   move      CDPA          CDCSBA
     C                   move      CDSN          CDCSSC
     C                   move      CDCN          CDCSCN
     C                   move      DDTE          CDCSDA
     C                   move      'C'           CDFLAG

     C                   write     XXCDUDP0

     C                   endif

     C                   move      CDSN          DSSC
     C                   move      CDPT          DDPT
     C                   move      CDPA          DSBA
     C*****              move      DDTE          DDTE

     C     w0key2        chain     XXCDUDV0                           9797

B00  C                   if        *in97 = *on

      * Set extraction fields
     C                   move      RECI          CDRECI
     C                   move      CDPA          CDCSBA
     C                   move      CDSN          CDCSSC
     C                   move      CDPT          CDCSCN
     C                   move      DDTE          CDCSDA
     C                   move      'D'           CDFLAG

     C                   write     XXCDUDP0

E01  C                   endif

E01  C                   endif

     C                   read      secdepl8                             9999

E00  C                   enddo

      *
      * Extract from UDEPPD: Depot only
      *

     C     *loval        setll     XXCOUPV1                           9999
     C  N99              read      XXCOUPV1                             9999

B00  C                   dow       *in99 = *OFF

B00  C                   if        UDDT <= BJRDNB

     C                   move      UDSN          DSSC
     C                   move      UDPT          DDPT
     C                   move      UDBA          DSBA
     C                   move      UDDT          DDTE

     C     w0key2        chain     XXCDUDV0                           9797

B01  C                   if        *in97 = *on

      * Set extraction fields
     C                   move      RECI          CDRECI
     C                   move      UDBA          CDCSBA
     C                   move      UDSN          CDCSSC
     C                   move      UDPT          CDCSCN
     C                   move      UDDT          CDCSDA
     C                   move      'D'           CDFLAG

     C                   write     XXCDUDP0

E01  C                   endif

E01  C                   endif

     C                   read      XXCOUPV1                             9999

E00  C                   enddo

     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *INZSR - Program Initialisation routine                           *
      *                                                                   *
      * Called by: Implicitly on program activation                       *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    WSECU
     C                   PARM                    WEDTE
     C                   PARM                    WPDTE
     C                   PARM                    WEVTP

B03  C                   if        WPDTE = *BLANKS
B03  C                   MOVE      '000000'      WPDTE
B03  C                   END
B03  C                   if        WEDTE = *BLANKS
B03  C                   MOVE      '000000'      WEDTE
B03  C                   END
      * Set the numeric counterpart for the Event Date

     C                   if        WEDTE = '00000' or WEDTE = *blanks
     C                   eval      WEDTN = 0
     C                   else
     C                   move      WEDTE         WEDTN
     C                   endif

      * Set the numeric counterpart for the Payment Date

     C                   if        WPDTE = '00000' or WPDTE = *blanks
     C                   eval      WPDTN = 0
     C                   else
     C                   move      WPDTE         WPDTN
     C                   endif

     C     w0key1        KLIST
     C                   KFLD                    SDSN
     C                   KFLD                    SDED
     C                   KFLD                    SDET
     C                   KFLD                    SDPD

     C     w0key2        KLIST
     C                   KFLD                    DSSC
     C                   KFLD                    DDPT
     C                   KFLD                    DSBA
     C                   KFLD                    DDTE

     C     w0key3        KLIST
     C                   KFLD                    CSSC
     C                   KFLD                    CSCN
     C                   KFLD                    CSBA
     C                   KFLD                    CSDA

      ** Read in Installation Data

     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C     *DTAARA       DEFINE                  LDA

     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA

     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database error.

     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EVAL      *inU7 = '1'
     C                   EVAL      *inU8 = '1'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF

     C                   EVAL      *inU7 = *ON
     C                   EVAL      *inU8 = *ON
     C                   EVAL      *inLR = *ON
     C                   RETURN

     C                   ENDSR
