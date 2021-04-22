     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*OVR *  OVRDBF FILE(DEHEVNTXX) TOFILE(DEHEVNTPD) SHARE(*NO)          *                       208221
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Historic Trans Comparison and selection')     *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DE0230 - Historic Events Comparison and Selection            *
      *                                                               *
      *  Function:  This module is called by DEC0230 which creates    *
      *             an OPNQRYF of new and changed records from        *
      *             the day's processing. This module will write      *
      *             the record to DENEVNTPD                           *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 08May01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  208221 - For FEES, when setting up all the details of the    *
      *           event, need to zeroise all numeric fields, and      *
      *           recreate FE events from position and fee accrued    *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************
      ** DE Historic Events File
     FDEHEVNTPD IF   E           K DISK
 
      ** DE Historic Events File
     FDEOEVNTL1 IF   E           K DISK    PREFIX(OL_)
     F                                     RENAME(DEEVNTP0:DEEVNTP2)
 
      ** DE New Events File
     FDENEVNTPD O    E           K DISK    PREFIX(NW_)
     F                                     RENAME(DEEVNTP0:DEEVNTP1)
 
      ** DE Old Events File                                                                   208221
     FDEOEVNTL2 IF   E           K DISK    PREFIX(OLI_)                                       208221
     F                                     RENAME(DEEVNTP0:DEEVNTOI)                          208221
                                                                                              208221
      ** DE New Events File                                                                   208221
     FDENEVNTL1 IF   E           K DISK    PREFIX(NWI_)                                       208221
     F                                     RENAME(DEEVNTP0:DEEVNTNI)                          208221
                                                                                              208221
      ** DE New Positions File                                                                208221
     FDENPOSNL1 IF   E           K DISK    PREFIX(NWI_)                                       208221
     F                                     RENAME(DEPOSNP0:DEPOSNNI)                          208221
                                                                                              208221
      ** DE Historic Transactions File                                                        208221
     FDEHTRANL1 IF   E           K DISK    PREFIX(HI_)                                        208221
     F                                     RENAME(DETRANP0:DETRANHI)                          208221
                                                                                              208221
      ** DE Historic Events File                                                              208221
     FDEHEVNTXX O    E           K DISK    PREFIX(HSO_) USROPN                                208221
     F                                     RENAME(DEEVNTP0:DEEVNTHO)                          208221
                                                                                              208221
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
 
     D DEEXTCTL      E DS                  EXTNAME(DEEXTCTL)
      ** EXTRACT CONTROL DATA
 
     D DEHEVNT       E DS                  EXTNAME(DEHEVNTPD)
      ** External Data Structure for Historic Events Details
 
     D DEOEVNT       E DS                  EXTNAME(DEHEVNTPD) PREFIX(OL_)
      ** External Data Structure for Old Historic Events Details
 
     D DENEVNT       E DS                  EXTNAME(DENEVNTPD) PREFIX(NW_)
      ** External Data Structure for New Events Details
 
     D DEHEVTX       E DS                  EXTNAME(DEHEVNTPD) PREFIX(HSO_)                    208221
      ** External Data Structure for Historic Events Details                                  208221
                                                                                              208221
     D DEOEVTI       E DS                  EXTNAME(DEOEVNTPD) PREFIX(OLI_)                    208221
      ** External Data Structure for Old Historic Events Details                              208221
                                                                                              208221
     D DENEVTI       E DS                  EXTNAME(DENEVNTPD) PREFIX(NWI_)                    208221
      ** External Data Structure for New Historic Events Details                              208221
                                                                                              208221
     D**  Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D**  Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D W#DATE          DS             6
     D Bday                    1      2
     D Aday                    3      4
 
     C     K#OLD         KLIST
     C                   KFLD                    K#MOD             2
     C**********         KFLD                    K#TREF           20                          CGL029
     C                   KFLD                    K#TREF           26                          CGL029
     C                   KFLD                    K#ASLI            1
     C                   KFLD                    K#PRDT            5 0
     C                   KFLD                    K#PRSQ            2 0
     C                   KFLD                    K#EVTP            2
     C                   KFLD                    K#EVRF            6
 
     C                   READ      DEHEVNTPD                              89
 
     C                   DOW       *IN89 = *Off
      *
      ** If Full Historic requested write record straight to DENPOSNPD
     C                   IF        DEFHDC = *Blank
     C                   CLEAR                   DENEVNT
     C                   MOVEL     DEHEVNT       DENEVNT
      *                                                                                       208221
      ** Reset accrueing fee events to event type 'FN'                                        208221
     C     I#TYPE        IFEQ      'FEES'                                                     208221
     C     E#EVTP        ANDEQ     'FE'                                                       208221
     C     E#ACIN        ANDEQ     'Y'                                                        208221
     C                   MOVEL     'FN'          NW_E#EVTP                                    208221
     C                   ENDIF                                                                208221
      *                                                                                       208221
     C                   WRITE     DEEVNTP1
 
     C     I#TYPE        IFEQ      'FEES'
     C     E#EVTP        ANDEQ     'IP'
     C                   EXSR      FEERECORD
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Set key for chain to DEOEVNTL1
     C                   EVAL      K#MOD = E#MOD
     C                   EVAL      K#TREF = E#TREF
     C                   EVAL      K#ASLI = E#ASLI
     C                   EVAL      K#PRDT = E#PRDT
     C                   EVAL      K#PRSQ = E#PRSQ
     C                   EVAL      K#EVTP = E#EVTP
     C                   EVAL      K#EVRF = E#EVRF
      *
      ** Check for record on file
     C     K#OLD         CHAIN     DEOEVNTL1                          88
      *
      ** If record exists check whether it has changed.                nterest Accrual Control
     C                   IF        *IN88 = *Off
     C                   IF        DEHEVNT <> DEOEVNT
     C                   CLEAR                   DENEVNT
     C                   MOVEL     DEHEVNT       DENEVNT
 
      ** Reset accrueing fee events to event type 'FN'                                        208221
     C     I#TYPE        IFEQ      'FEES'                                                     208221
     C     E#EVTP        ANDEQ     'FE'                                                       208221
     C     E#ACIN        ANDEQ     'Y'                                                        208221
     C                   MOVEL     'FN'          NW_E#EVTP                                    208221
     C                   ENDIF                                                                208221
      *                                                                                       208221
     C                   WRITE     DEEVNTP1
 
     C     I#TYPE        IFEQ      'FEES'
     C     E#EVTP        ANDEQ     'IP'
     C                   EXSR      FEERECORD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ELSE
      *
      ** Write record to DENEVNTPD
     C                   CLEAR                   DENEVNT
     C                   MOVEL     DEHEVNT       DENEVNT
 
      ** Reset accrueing fee events to event type 'FN'                                        208221
     C     I#TYPE        IFEQ      'FEES'                                                     208221
     C     E#EVTP        ANDEQ     'FE'                                                       208221
     C     E#ACIN        ANDEQ     'Y'                                                        208221
     C                   MOVEL     'FN'          NW_E#EVTP                                    208221
     C                   ENDIF                                                                208221
      *                                                                                       208221
     C                   WRITE     DEEVNTP1
 
     C     I#TYPE        IFEQ      'FEES'
     C     E#EVTP        ANDEQ     'IP'
     C                   EXSR      FEERECORD
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   READ      DEHEVNTPD                              89
     C                   ENDDO
 
      *                                                                                       208221
      ** For Lending fees have to generate fee events from the position                       208221
     C     I#TYPE        IFEQ      'FEES'                                                     208221
                                                                                              208221
     C                   OPEN      DEHEVNTXX                                                  208221
                                                                                              208221
     C     NPOSNKY       KLIST                                                                208221
     C                   KFLD                    N#MOD             2                          208221
     C**********         KFLD                    N#TREF           20                   208221 CGL029
     C                   KFLD                    N#TREF           26                          CGL029
     C                   KFLD                    N#ASLI            1                          208221
     C                   KFLD                    N#PRDT            5 0                        208221
                                                                                              208221
     C     OEVNTK2       KLIST                                                                208221
     C                   KFLD                    NWI_P#MOD                                    208221
     C                   KFLD                    NWI_P#TREF                                   208221
     C                   KFLD                    O#EVTP            2                          208221
                                                                                              208221
     C     OEVNTK3       KLIST                                                                208221
     C                   KFLD                    NWI_P#MOD                                    208221
     C                   KFLD                    NWI_P#TREF                                   208221
                                                                                              208221
      ** Read the New Historic position file.                                                 208221
      ** This will the interest amounts moved to the fee accrued field                        208221
      ** for calculated fees.                                                                 208221
     C     NPOSNKY       SETLL     DENPOSNL1                              89                  208221
     C                   READ      DENPOSNL1                              89                  208221
                                                                                              208221
     C                   MOVEL     *BLANKS       SAVEDTREF        20                          208221
     C                                                                                        208221
     C                   DOW       *IN89 = *Off                                               208221
      ** Only do something if the fee accrued field is not zero.                              208221
      ** This is so that fees with no periods do not generate new event                       208221
     C                   IF        NWI_P#FEAC <> 0                                            208221
     C                   IF        SAVEDTREF <> NWI_P#TREF                                    208221
      ** Transaction has not been processed before so no data is set up                       208221
      *                                                                                       208221
      ** Check for fee record on new events files                                             208221
     C                   IF        NWI_P#ACIN = 'Y'                                           208221
     C                   MOVEL     'IP'          O#EVTP                                       208221
     C                   ELSE                                                                 208221
     C                   MOVEL     'FN'          O#EVTP                                       208221
     C                   ENDIF                                                                208221
     C     OEVNTK2       CHAIN     DENEVNTL1                          88                      208221
      *                                                                                       208221
      ** If record exists write a record with the details from position                       208221
     C                   IF        *IN88 = *Off                                               208221
     C                   CLEAR                   DENEVNT                                      208221
     C                   MOVEL     DENEVTI       DENEVNT                                      208221
     C                   EXSR      WRTREC                                                     208221
                                                                                              208221
     C                   ELSE                                                                 208221
      *                                                                                       208221
      ** Check for fee record on old events files                                             208221
      ** This file will not have the changed fee events with type 'FN'.                       208221
     C     OEVNTK3       SETLL     DEOEVNTL2                          88                      208221
     C                   READ      DEOEVNTL2                              88                  208221
     C                   DOW       *IN88 = *OFF AND OLI_E#TREF = NWI_P#TREF AND               208221
     C                             OLI_E#EVTP <> 'FE' AND OLI_E#EVTP <> 'IP'                  208221
     C                   READ      DEOEVNTL2                              88                  208221
     C                   ENDDO                                                                208221
      ** If record exists write a record with the details from position                       208221
     C                   IF        *IN88 = *OFF AND OLI_E#TREF = NWI_P#TREF                   208221
     C                   CLEAR                   DENEVNT                                      208221
     C                   MOVEL     DEOEVTI       DENEVNT                                      208221
     C                   EXSR      WRTREC                                                     208221
     C                   ELSE                                                                 208221
      *                                                                                       208221
      ** Get the transaction record for the fee to get the fee code.                          208221
      ** Get a event record for the fee.                                                      208221
      ** Most likely on old events as this contains all history from                          208221
      ** yesterday.                                                                           208221
     C     OEVNTK3       CHAIN     DEHTRANL1                          88                      208221
     C     OEVNTK3       CHAIN     DEOEVNTL2                          88                      208221
     C                   IF        *IN88 = *ON                                                208221
      ** If not found, check on the new events in case this is a new                          208221
      ** fee.                                                                                 208221
     C     OEVNTK3       CHAIN     DENEVNTL1                          87                      208221
     C                   ENDIF                                                                208221
     C                   CLEAR                   DENEVNT                                      208221
     C                   MOVEL     DEOEVTI       DENEVNT                                      208221
     C                   IF        *IN88 = *ON AND *IN87 = *OFF                               208221
     C                   MOVEL     DENEVTI       DENEVNT                                      208221
     C                   ENDIF                                                                208221
     C                   IF        *IN87 = *ON                                                208221
      ** If an event is not found on old or new events then need to                           208221
      ** set up all event details.                                                            208221
      ** This can happen if the only event for the fee is the fee event                       208221
      ** and have not reached payment date yet.                                               208221
     C**********         Z-ADD     0             NW_E#BRTT                             208221 CSD103
     C                   MOVE      *BLANKS       NW_E#BRTT                                    CSD103
     C                   Z-ADD     0             NW_E#BRTE                                    208221
     C                   Z-ADD     0             NW_E#RTSP                                    208221
     C                   Z-ADD     0             NW_E#IRAT                                    208221
     C                   Z-ADD     0             NW_E#FSRP                                    208221
     C                   Z-ADD     0             NW_E#CRAT                                    208221
     C                   Z-ADD     0             NW_E#PRAM                                    208221
     C                   Z-ADD     0             NW_E#INTA                                    208221
     C                   Z-ADD     0             NW_E#COFA                                    208221
     C                   Z-ADD     0             NW_E#CHRG                                    208221
     C                   Z-ADD     0             NW_E#COMM                                    208221
     C                   Z-ADD     0             NW_E#NOML                                    208221
     C                   Z-ADD     0             NW_E#PRIC                                    208221
     C                   Z-ADD     0             NW_E#CPDP                                    208221
     C                   Z-ADD     0             NW_E#CFCT                                    208221
     C                   Z-ADD     0             NW_E#NXCD                                    208221
     C                   Z-ADD     0             NW_E#CASH                                    208221
     C                   Z-ADD     0             NW_E#FXMG                                    208221
     C                   MOVEL     NWI_P#MOD     NW_E#MOD                                     208221
     C                   MOVEL     NWI_P#TREF    NW_E#TREF                                    208221
     C                   MOVEL     NWI_P#ASLI    NW_E#ASLI                                    208221
     C                   MOVEL     NWI_P#CCY     NW_E#CCY                                     208221
     C                   MOVEL     NWI_P#NCDP    NW_E#NCDP                                    208221
     C                   MOVEL     NWI_P#NMDP    NW_E#NMDP                                    208221
     C                   IF        NWI_P#FEAC < 0                                             208221
     C                   MOVEL     'O'           NW_E#IO                                      208221
     C                   ELSE                                                                 208221
     C                   MOVEL     'I'           NW_E#IO                                      208221
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
     C                   MOVEL     NWI_P#ACIN    NW_E#ACIN                                    208221
     C                   MOVEL     HI_T#FEEC     NW_E#FEEC                                    208221
     C                   EXSR      WRTREC                                                     208221
     C                   ENDIF                                                                208221
     C                   ENDIF                                                                208221
                                                                                              208221
     C                   ELSE                                                                 208221
      ** Transaction has been processed before so just change the date                        208221
      ** and amounts.                                                                         208221
     C                   EXSR      WRTREC                                                     208221
     C                   ENDIF                                                                208221
     C                   MOVEL     NWI_P#TREF    SAVEDTREF                                    208221
     C                   ENDIF                                                                208221
                                                                                              208221
     C                   READ      DENPOSNL1                              89                  208221
     C                   ENDDO                                                                208221
     C                   ENDIF                                                                208221
                                                                                              208221
     C                   EVAL      *INLR = *On
     C                   RETURN
     C
 
     C********************************************************************
      /SPACE 5
     C********************************************************************
     C     FEERECORD     BEGSR
 
     C*******************MOVEL     'FE'          NW_E#EVTP                                    208221
     C                   MOVEL     'FN'          NW_E#EVTP                                    208221
     C                   Z-ADD     3             NW_E#PRSQ
     C                   Z-ADD     E#INTA        NW_E#FEE
     C                   Z-ADD     E#INTA        NW_E#TAMT
     C                   Z-ADD     0             NW_E#INTA
     C                   Z-ADD     0             NW_E#MVNO
     C                   MOVEL     'I'           NW_E#IO
      *
     C                   WRITE     DEEVNTP1
      *
     C                   ENDSR
      *
     C********************************************************************
      /SPACE 5                                                                                208221
     C********************************************************************                    208221
     C     WRTREC        BEGSR                                                                208221
                                                                                              208221
     C                   Z-ADD     NWI_P#IACD    NW_E#PRDT                                    208221
     C                   MOVEL     'FE'          NW_E#EVTP                                    208221
     C                   Z-ADD     3             NW_E#PRSQ                                    208221
     C                   Z-ADD     NWI_P#FEAC    NW_E#FEE                                     208221
     C                   Z-ADD     NWI_P#FEAC    NW_E#TAMT                                    208221
     C                   Z-ADD     0             NW_E#MVNO                                    208221
     C                   Z-ADD     1             EvntSeq           3 0                        208221
     C                   MOVE      EvntSeq       E#EVRF                                       208221
      *                                                                                       208221
     C                   WRITE     DEEVNTP1                                                   208221
      *                                                                                       208221
     C                   CLEAR                   DEHEVTX                                      208221
     C                   MOVEL     DENEVNT       DEHEVTX                                      208221
     C                   WRITE     DEEVNTHO                                                   208221
      *                                                                                       208221
     C                   ENDSR                                                                208221
      *                                                                                       208221
     C********************************************************************                    208221
      /SPACE 5
     C********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
     C                   PARM                    I#TYPE            4
 
      **  Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Read Extract Control Data
 
     C     *DTAARA       DEFINE                  DEEXTCTL
     C                   IN        DEEXTCTL
      *
     C                   ENDSR
      *
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
