     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056560
/*STD *  RPGSQLBND                                                    *                     MD056560
/*EXI *  TEXT('Midas ME Translate message for funds transfer')        *
     F*****************************************************************
     F*                                                               *
     F*  Midas - Message Management Module                            *
     F*                                                               *
     F*  ME1100 - Translate Message For Funds Transfer                *
     F*                                                               *
     F*  Function:  This program extracts the required fields from    *
     F*  the Network message files and prepares them ready for placing*
     F*  in the relevant input fields.                                *
     F*                                                               *
     F*  Called By: FT0040  - Outgoing Payments Maintenance           *
     F*             FT0050  - Incomimg Payments Maintenance           *
     F*             FT0300  - Midas FT Auto Generation                *
     F*             FT101HRTV  - Midas FT RFT Header Retrieve (API)   *
     F*             FT101CRTV  - Midas FT RFT Detail Retrieve (API)   *
     F*             FT102HRTV  - Midas FT CCT Header Retrieve (API)   *
     F*             FT102CRTV  - Midas FT CCT Detail Retrieve (API)   *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD059365           Date 06Dec21               *
      *  Prev Amend No. UUC104             Date 12Oct20               *
      *                 MD058361           Date 26Jun21               *
      *                 MD056752           Date 20Sep20               *
      *                 MD056560           Date 31Aug20               *
      *                 AR928996A          Date 03May12               *
      *                 AR928996           Date 27Mar12               *
      *                 MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24998           Date 17Jul09               *
      *                 BUG24802           Date 08Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
     F*                 172911             Date 02Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 14May00               *
      *                 178181             Date 27Apr00               *
     F*                 CFT006             DATE 02NOV99               *
      * Midas DBA 3.02 -----------------------------------------------*
      * Midas DBA 3.01 -----------------------------------------------*
     F*                 CGL009             DATE 08JUL99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 145199             DATE 16OCT98               *
     F*                 CRT002             Date  1DEC95               *
     F*                 069250             Date 03MAY94               *
     F*                 HUB001             DATE 18NOV93               *
     F*                 S01435             DATE 23JUL93               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD059365 - Mis-aligned ME1100 copy sources                   *
      *  UUC104 - MPM Integration (Upgrade of 1.4.11.06 CAR UUC069)   *
      *           Use copy hook ME1100DDC1, ME1100DIPG, ME1100C008    *
      *  MD058361 - Correct SQL request to access MEINFJW0            *
      *  MD056752 - Deliverable Data Split for MEINFMPD               *
      *  MD056560 - Deliverable Data Split for SDMTAGPD               *
      *  AR928996A- Data truncation error. Amended PDATA and PDAT2    *
      *             data structure field to have the correct length.  *
      *             (Child: AR928997A)                                *
      *  AR928996 - Data lost due to rate field :36: being truncated. *
      *             (Child: AR928997)                                 *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  BUG24802 - Sending institution in STP is missing             *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
     F*  172911 - Amount of incoming SWIFT messages are truncated.   *
      *  CFT014 - Straight-through processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
     F*  175479 - FONTIS: deal reference field                        *
     F*  178181 - Sender's mapping is incorrect for MT101             *
     F*  CFT006 - MT101/2 message addtion for outgoing/incoming RFT   *
     F*  CGL009 - Midas IAT/TPP FONTIS interface                      *
     F*  145199 - Recompile for changes to MEINCRPD and MEINMPPD made *
     F*           in Year 2000 fix 124673.                            *
     F*  CRT002 - Retail Branch Access.                               *
     F*  069250 - Remove dummy OVRDBF command from creation parms.    *
     F*  HUB001 - Incoming BOJ Message Management                     *
     F*  S01435 - Incoming Message Management                         *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  Indicator usage                                              *
     F*  ~~~~~~~~~~~~~~~                                              *
     F*                                                               *
     F*  11    Record Identifier for MEINDTS2                         *
     F*  12    Record Identifier for MEINDTS2                         *
     F*  50    First cycle completed                                  *
     F*  60    EOF on MEINDTS2                                        *
     F*  61    EOF on MEINFML1                                        *
     F*  63    Match found on table LOKUP                             *
     F*  90    Chain fail                                             *
     F*  99    EOF on Read                                            *
     F*                                                               *
     F*  U7/U8 Error Ocurred                                          *
     F*  LR    End program                                            *
     F*                                                               *
     F*****************************************************************
     FMEINCRL1  IF   E           K DISK    INFSR(SRFILE)
     F                                     USROPN
      *
      *  Incoming Message Control
      *
     FMEINMPL1  IF   E           K DISK    INFSR(SRFILE)
     F                                     USROPN
      *
      *  Incoming Message Part Details
      *
     FMEINDTS2  IF   E           K DISK    INFSR(SRFILE)
     F                                     USROPN
      *
      *  Incoming Message Detail - multiple formats
      *
     F*MEINFML1* IF   E           K DISK    INFSR(SRFILE)                                   MD056752
     F**********                            USROPN                                          MD056752
      *
      *  Incoming Message Translation File
      *
     F*SDMTAGL0* IF   E           K DISK    INFSR(SRFILE)                        CRT002     MD056560
     F**********                           USROPN                                           MD056560
      *                                                                   CRT002
      *  Message tag                                                      CRT002
      *                                                                   CRT002
     F/COPY WNCPYSRC,ME1100DFPG
      *
      *  /Copy point for File Definition
      *
     F/EJECT
      *
      *  Copyright table
      *
     D*COPY*MECPYSRC,SRERRE                                                                 MD056560
     D/COPY MECPYSRC,SRERRELE                                                               MD056560
      *
      *  End of Copysource for error processing
      *
     D LIN             S             35    DIM(6)
      *  Special case for :72: in FONTIS                                  CGL009
     D********************L72       240  1                          CGL009175479
     D L72             S              1    DIM(250)                                              175
      *
      *  Multiple message line details
      *
      *  Special case for :72: in FONTIS                                  CGL009
     D********************IN72      240  1                          CGL009175479
     D********************OT72      240  1                          CGL009175479
      *
      *  Line arrays to fill parameter data structures
      *
     D********************TFLD    1  15 10   TPRM    4                    CRT002
     D********************TFLD    1  18 10   TPRM    4              CRT002CFT006
     D/COPY WNCPYSRC,ME1100E001
     D***********         TFLD    1  52 10   TPRM    5             CFT006 CFT014
     D**********          TFLD    1  55 10   TPRM    5                                 CFT014 CSW209
     D**********          TFLD    1  68 10   TPRM    5                                 CSW209 CER030
     D TFLD            S             10    DIM(69) CTDATA PERRCD(1)
     D TPRM            S              5    DIM(69) ALT(TFLD)
      *
      *  Field / Parameter Data Structure relationship
      *
     D TVAA            S              1    DIM(16)                                               172
      *  Array to format amount to prevent the last digit of the amount   172911
      *  from being truncated.                                            172911
      *                                                                   172911
     D/COPY WNCPYSRC,ME1100DEPG
      *
      *  /Copy point for Arrays
      *
      ** Array of Commitment Job Names                                                        CSC022
     D CMTJOB          S             10    DIM(10)
      *
      *  /Copy point for Input Specs
      *
     D CPYR@#          DS
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      *  Define rundat data area
      *
     D*COPY*MECPYSRC,SRERRI                                                                 MD056560
     D/COPY MECPYSRC,SRERRILE                                                               MD056560
      *
      *  End of Program Error Processing copysource member
      *
      *
      *                  ****************************
      *
     D PTAG            DS
      *
      *  Re-define Incoming Message Tag field
      *
     D  DTMTG                  1      5
     D  P1MTG                  1      3
     D  P2MTG                  1      2
      *
     D*COPY*MECPYSRC,SME1100P                                                               MD056752
     D/COPY MECPYSRC,SME1100PLE                                                             MD056752
     D DSIN            DS
      *
      *  'IN' data structure for tag details - used in formatting
      *
      *  General fields
     D  INTAG                  1      5
     D  INTYPE                 6      6
     D**********                              7  24 INCODE                                    CGL029
     D  INCODE                 7     30
      *
      *  Multiple lines
      *
     D**********                             25 234 IN                                        CGL029
     D  IN                    31    240
     D                                     DIM(6)
     D DSIN72          DS                                                       CGL009
      *                                                                   CGL009
      *  'IN' data structure for tag 72 for FONTIS                        CGL009
      *                                                                   CGL009
      *  General fields                                                   CGL009
     D  I72TAG                 1      5                                         CGL009
     D  I72TYP                 6      6                                         CGL009
      *                                                                   CGL009
      *  Multiple lines                                                   CGL009
      *                                                                   CGL009
     D****************************************7 246 IN72            CGL009175479
     D  IN72                   7    256                                         175479
     D                                     DIM(250)                                              175
      *
     D DSOUT           DS
      *
      *  'OT' data structure for tag details - used in formatting         CFT006
      *
      *  General fields
     D  OTTAG                  1      5
     D  OTTYPE                 6      6
     D**********                              7  24 OTCODE                                    CGL029
     D  OTCODE                 7     30
      *
      *  Multiple lines
      *
     D**********                             25 234 OUT                                       CGL029
     D  OUT                   31    240
     D                                     DIM(6)
      *
     D DSOT72          DS                                                       CGL009
      *                                                                   CGL009
      *  'OT' data structure for tag 72 for FONTIS                        CGL009
      *                                                                   CGL009
      *  General fields                                                   CGL009
     D  O72TAG                 1      5                                         CGL009
     D  O72TYP                 6      6                                         CGL009
      *                                                                   CGL009
      *  Multiple lines                                                   CGL009
      *                                                                   CGL009
     D****************************************7 246 OT72            CGL009175479
     D  OT72                   7    256                                         175479
     D                                     DIM(250)                                              175
      *
     D SCCMT           DS           256
     D  CMTNUM                 1      3  0
     D  CMTARR                 4    103
      *                                                                                       CER030
      ** Short Data Structure                                                                 CER030
      *                                                                                       CER030
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *                                                                                       CER030
      ** External SAR Details                                                                 CER030
      *                                                                                       CER030
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SDMTAG        E DS                  EXTNAME(SDMTGJW0)                                MD056560
     D MEINFM        E DS                  EXTNAME(MEINFJW0)                                MD056752
     D/COPY WNCPYSRC,ME1100DIPG                                                             MD059365
     I/EJECT
      *
      * Allocate record identification indicator to each format
      * of Incoming Message Detail multiple format file.
      *
      * Rename fields on second format to the same as the first format.
      *
     I@INDTS2       11
      *
     I@IN35S2       12
     I              DSMSGR                      DTMSGR
     I              DSSEQN                      DTSEQN
     I              DSMTG                       DTMTG
     I              DSPART                      DTPART
     I              DSFPID                      DTFPID
     I              DSMSEQ                      DTMSEQ
      *
     I***/COPY*WNCPYSRC,ME1100DIPG                                                          MD059365
      *                                                                                       CER030
     I/EJECT
      *****************************************************************
      *                 M A I N L I N E
      *****************************************************************
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      *  Define entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    W0ACT             8            Action
     C                   PARM                    PHEAD                          General Details
     C                   PARM                    PDATA                          Message Details
     C                   PARM                    PDAT2
     C                   PARM                    W0RTN             7            Return Code
     C/COPY WNCPYSRC,ME1100C013
      *
      *  Set up primary reference
      *
     C                   MOVEL     PHEAD         W0PREF
      *
      * Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      SRINIT
     C                   END
      *
      *  Determine the mode of processing and execute subroutine :-
      *
      *
      *  Action Code : *TRANS
      *  --------------------
      *
      *  Called from FT0050/40 to translate the data of the message.
      *
      *
      *  If invalid Action Code passed then report as an error.
      *
     C     W0ACT         CASEQ     '*TRANS  '    SRPROC
     C                   CAS                     SRACT
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      *  Return to calling program
      *
     C                   RETURN
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRPROC   : Controlling Subroutine For Translation Process    *
      *                                                               *
      *  CALLED BY: Main processing section                           *
      *                                                               *
      *  CALLS    : SRPFIL  - Access Detail files for tag nos.        *
      *             SRERR   - Error Processing                 .      *
      *                                                               *
      *****************************************************************
     CSR   SRPROC        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRPROC'      @STK(Q)
      *
      *  Clear parameter data structure to hold message details
     C/COPY WNCPYSRC,ME1100C012
      *
     C                   CLEAR                   PDATA
     C     CSW209        IFEQ      'Y'
     C                   CLEAR                   PDAT2
     C                   ENDIF
     C/COPY WNCPYSRC,ME1100C010
      *
      *          **************************************
      *
      *  Access Incoming Message Control File
      *
     C     PHMSGR        CHAIN     MEINCRL1                           90
      *
      *  If record not found - database error
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'MEINCRL1'    W0FILE                         ***************
     C                   MOVEL     PHMSGR        W0KEY                          * DB ERROR 01 *
     C                   Z-ADD     1             W0ERNB                         ***************
     C                   MOVEL     'MEM5004'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
     C/COPY WNCPYSRC,ME1100C001
      *
      *  Move Control fields into parameter data structure
      *
     C                   MOVEL     CRSNDR        PSNDR                          Sender
     C                   MOVEL     CRMTPY        PMTPY                          Msg Type
     C                   MOVEL     CRMPRY        PMPRY                          Msg Priority
     C                   MOVEL     CRBRCA        PBRCA                          Branch
     C                   MOVEL     CRNWRK        PNWRK                          Network
      *
     C                   MOVEL     CRMIR         PHMIR
     C                   MOVEL     CRMOR         PHMOR
     C/COPY WNCPYSRC,ME1100C009
      *
      *  Extract Sender Address information and place in data structure
      *
     C                   MOVEL     *BLANKS       SVTAG
     C                   MOVEL     'SNDR'        SVTAG
     C                   MOVEL     *BLANKS       TRTAG
     C                   MOVEL     'SNDR'        TRTAG
     C                   MOVEL     CRSNDR        TMLIN
     C                   Z-ADD     1             L
     C                   Z-ADD     1             B                 3 0                         CGL00
      * SENDER is not a SWIFT TAG. In this case the call of S/R           178181
      * is not made after having found a record in MEINDTS2               178181
      * (like in SRPFIL).                                                 178181
      * In MT100 all the mapping is done with variable PXX                178181
      * therefore we need to execute SRMAP with KFPART > 0.               178181
      * In MT101 or MT102 mapping can group variables as PHXX             178181
      * or PXX. SRMAP will map the SWIFT TAG to PHXX if KFPART = 0        178181
      * otherwise it will map the tag to PXX.                             178181
      * For MT101 MT102 we assume the SENDER is likely to be mapped       178181
      * on the header screen, like all the tags of sequence A.            178181
      * Therefore we call SRMAP with KFPART = 0.                          178181
     C     CRMTPY        IFNE      '101'                                                       17818
     C********** CRMTPY    ANDNE'102'                                                178181 BUG24802
     C                   Z-ADD     *HIVAL        KFPART                                        CFT00
     C                   ELSE                                                                  17818
     C                   Z-ADD     0             KFPART                                        17818
     C                   ENDIF                                                                 17818
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     *BLANKS       SVMSEQ
     C                   MOVEL     *BLANKS       KFMSEQ
     C                   MOVEL     *BLANKS       KFMSQN
     C                   ENDIF
     C                   EXSR      SRMAP
      *
      *          **************************************
      *
      *  Access Incoming Message Detail file.
      *
      *  Initially get the details for the Part 0 record as this holds
      *  tag data common to all other part nos. The trailer tags also
      *  are in part 0 but these are not accessed as they occur after
      *  all the tag details.
      *
      *  Then get all message details for the Part No. that was passed
      *  as a parameter.
      *
      *  For each part there will be several tags, for some of the tags
      *  there will be either one or multiple lines. All details for a
      *  tag are extracted and stored in the relevant format of the
      *  DSTRAN data structure.
      *
      *  Clear work fields
      *
     C                   MOVEL     *BLANKS       SVTAG                          Tag No.
      *
      *  Set up key for Part 0
      *
     C                   Z-ADD     PHMSGR        KFMSGR                         Msg Ref.
     C                   Z-ADD     0             KFPART                         Part No.
     C                   MOVEL     *BLANKS       KFTAG                          Tag No.
     C                   Z-ADD     0             KFSEQ                          Sequence No.
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     *BLANKS       KFMSQN
     C                   ENDIF
      *
      *  Extract details from file
      *
     C                   EXSR      SRPFIL
      *                                                                         CFT006
      *  If it was asked to extract tags belonging to part 0                    CFT006
      *  we don't need to make it twice                                         CFT006
      *                                                                         CFT006
     C     PHPART        IFEQ      0
     C                   MOVEL     'MIN0096'     W0RTN
     C                   GOTO      EXPROC
     C                   ENDIF
      *
      *  Set up key for Message Part selected by User
      *
     C                   Z-ADD     PHPART        KFPART                         Part No.
     C                   MOVEL     *BLANKS       KFTAG                          Tag No.
     C                   Z-ADD     0             KFSEQ                          Sequence No.
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     *BLANKS       SVMSEQ
     C                   MOVEL     *BLANKS       KFMSEQ
     C                   ENDIF
      *
      *  Extract details from file
      *
     C                   EXSR      SRPFIL
      *
      *  /Copy point for analysis/decode
      *
     C/COPY WNCPYSRC,ME1100DDC1
      *
      * Return to calling program for further processing based on the
      * value of the return code.
      *
     C                   MOVEL     'MIN0096'     W0RTN
      *
      *  Unwind subroutine stack name
      *
     C     EXPROC        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRPFIL   : Read files for Part Nos Tags                      *
      *                                                               *
      *  CALLED BY: SRPROC  - Controlling Sub routine for Translation *
      *                                                               *
      *  CALLS    : SRDETL  - Extract each tag's detail lines         *
      *             SRMAP   - Map Message Details to Parameters       *
      *                                                               *
      *****************************************************************
     CSR   SRPFIL        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRPFIL'      @STK(Q)
      *
      *  Access Incoming Message Detail file for the part no.
      *
      *  For each part there will be several tags, for some of the tags
      *  there will be either one or multiple lines. All details for a
      *  tag are extracted and stored in the relevant format of the
      *  DSTRAN data structure.
      *
      *  When the tag data is fully extracted then the data must be
      *  placed in the correct tag parameter data structure. The data
      *  structure is determined by accessing the Translation File
      *  using the tag no.
      *
      *  If a record is found it gives the FT field name into which the
      *  data will finally be placed (a function of the calling pgm).
      *
      *  This program hard codes the relationship bewteen the FT field
      *  and the tag parameter data structures by means of a table.
      *
      *  Set limits and read first record for the Message Ref/Part
      *
     C                   MOVE      '0'           *IN11                                         CRT00
     C                   MOVE      '0'           *IN12                                         CRT00
     C     KYINDT        SETLL     MEINDTS2
     C                   READ      MEINDTS2                               60
      *
     C  N60DTMSGR        IFNE      KFMSGR
     C     DTPART        ORNE      KFPART
     C                   MOVE      '1'           *IN60
     C                   END
      *
      * Read until end of part no.
      *
     C     *IN60         DOWEQ     '0'
      *
      * If a new Tag no. is read then map the previous tag's data into
      * the relevant tag parameter data structure. Save the new tag no.
      * and initialise fields. (Do not do for first tag in pgm).
      *
     C     SVTAG         IFNE      DTMTG
     C     SVTAG         ANDNE     *BLANKS
     C     SVMSEQ        ORNE      DTMSEQ
     C     CSW209        ANDEQ     'Y'
     C                   EXSR      SRMAP
     C                   END
      *
     C                   MOVEL     DTMTG         SVTAG
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     DTMSEQ        SVMSEQ
     C                   ENDIF
      *                                                                   CGL009
     C                   SELECT                                                                CGL00
      * FONTIS network                                                    CGL009
      * --------------                                                    CGL009
     C     PNWRK         WHENEQ    'FONTIS'                                                    CGL00
      *                                                                   CGL009
     C                   SELECT                                                                CGL00
      *                                                                   CGL009
      * In FONTIS tag :72: has a different structure                      CGL009
      * Move the line details of the tag into the relevant format of      CGL009
      * the DSFONT data structure                                         CGL009
      *                                                                   CGL009
     C     SVTAG         WHENEQ    ':72:'                                                      CGL00
     C                   EXSR      SRDE72                                                      CGL00
      *                                                                   CGL009
      * Other tags in FONTIS                                              CGL009
      * Move the line details of the tag into the relevant format of      CGL009
      * the DSTRAN data structure                                         CGL009
      *                                                                   CGL009
     C                   OTHER                                                                 CGL00
     C                   EXSR      SRDETL                                                      CGL00
      *                                                                   CGL009
     C                   ENDSL                                                                 CGL00
      *                                                                   CGL009
      * Other Networks                                                    CGL009
      * --------------                                                    CGL009
     C                   OTHER                                                                 CGL00
      *
      * Move the line details of the tag into the relevant format of
      * the DSTRAN data structure
      *
     C                   EXSR      SRDETL
      *                                                                   CGL009
     C                   ENDSL                                                                 CGL00
      *
      * Check if another record to be read for the Part No.
      *
     C                   MOVE      '0'           *IN11                                         CRT00
     C                   MOVE      '0'           *IN12                                         CRT00
     C                   READ      MEINDTS2                               60
      *
     C  N60DTMSGR        IFNE      KFMSGR
     C     DTPART        ORNE      KFPART
     C                   MOVE      '1'           *IN60
     C                   END
      *
     C                   ENDDO
      *
      * Map last Tag no. for the Part No.
      *
     C     SVTAG         IFNE      *BLANKS
     C                   EXSR      SRMAP
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXPFIL        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRDETL   : Extract each tag's detail lines                   *
      *                                                               *
      *  CALLED BY: SRPFIL - Read Files for Part Nos/Tags             *
      *                                                               *
      *  CALLS    :        -                                          *
      *                                                               *
      *****************************************************************
     CSR   SRDETL        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRDETL'      @STK(Q)
      *
      *  Determine which record format is being used
      *
     C                   MOVEL     *BLANKS       WKDATA
     C   11              MOVEL     DTMFLD        WKDATA
     C   12              MOVEL     DSMF35        WKDATA
      *
      *  Move in general fields to the data structure
      *
     C                   MOVEL     SVTAG         TRTAG
     C                   MOVEL     *BLANKS       TRCODE
      *
      *  Map message data into the DSTRAN data structure.
      *  (DSTRAN allows for 3 different formats. They are defined in)
      *  (this program but are really only relevant for subsequent  )
      *  (processing.                                               )
      *
      *  Increment line count of tag (important for multiple line msgs)
      *
      *  Fill next available line.
      *
      *  Move the line array into the data structure field.
      *  It is done for each line because it is the least complicated
      *  way of coding and most will not have all 6 lines.
      *
      *  Only the first 35 are used as ISO formats are only supported
      *  by FT
      *
      *
      * If more than 6 lines stored in the array, just ignore the
      * remaining lines.  Since it will be mapped to the FT transaction
      * input screen.
      *
     C     L             IFLT      6
     C                   ADD       1             L                 2 0
     C                   MOVEL     WKDATA        LIN(L)
     C                   END
      *
     C                   MOVEA     LIN           TMLIN
      *
      *  Unwind subroutine stack name
      *
     C     EXDETL        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT                                                              CGL009
      *****************************************************************   CGL009
      *                                                               *   CGL009
      *  SRDE72   : Extract tag :72:                                  *   CGL009
      *                                                               *   CGL009
      *  CALLED BY: SRPFIL - Read Files for Part Nos/Tags             *   CGL009
      *                                                               *   CGL009
      *  CALLS    :        -                                          *   CGL009
      *                                                               *   CGL009
      *****************************************************************   CGL009
     CSR   SRDE72        BEGSR                                                                 CGL00
      *                                                                   CGL009
      *  Set up subroutine stack name                                     CGL009
      *                                                                   CGL009
     C                   ADD       1             Q                                             CGL00
     C                   MOVEL     'SRDE72'      @STK(Q)                                       CGL00
      *                                                                   CGL009
      *  Determine which record format is being used                      CGL009
      *                                                                   CGL009
     C                   MOVEL     *BLANKS       WKDATA                                        CGL00
     C   11              MOVEL     DTMFLD        WKDATA                                        CGL00
     C   12              MOVEL     DSMF35        WKDATA                                        CGL00
      *                                                                   CGL009
      *  Move in general fields to the data structure                     CGL009
      *                                                                   CGL009
     C                   MOVEL     SVTAG         FNTAG                                         CGL00
      *                                                                   CGL009
      *  Map message data into the DSFONT data structure.                 CGL009
      *  (DSFONT allows for different formats.                            CGL009
      *                                                                   CGL009
      *  Increment line count of tag (important for multiple line msgs)   CGL009
      *                                                                   CGL009
      *  Fill next available line.                                        CGL009
      *                                                                   CGL009
      *  Move the line array into the data structure field.               CGL009
      *  It is done for each line because it is the least complicated     CGL009
      *  way of coding and most will not have all 6 lines.                CGL009
      *                                                                   CGL009
      *  In FONTIS the first line of tag :72: can exceed 35 chars (it     CGL009
      ***can*be*65*chars*indeed)*********                           CGL009175479
      *  can be 100 chars indeed)                                         175479
      *                                                                   CGL009
      *                                                                   CGL009
      * If more than 6 lines stored in the array, just ignore the         CGL009
      * remaining lines.  Since it will be mapped to the FT transaction   CGL009
      * input screen.                                                     CGL009
      *                                                                   CGL009
     C     L             IFLT      6                                                           CGL00
     C                   ADD       1             L                 2 0                         CGL00
     C                   MOVEA     WKDATA        L72(B)                                        CGL00
      **First*line*of*:72:**has*a*length*65                         CGL009175479
      * First line of :72:  has a length 100                              175479
     C     L             IFEQ      1                                                           CGL00
     C*********************ADD  65        B                         CGL009175479
     C                   ADD       100           B                                             17547
     C                   ELSE                                                                  CGL00
     C                   ADD       35            B                                             CGL00
     C                   END                                                                   CGL00
     C                   END                                                                   CGL00
      *                                                                   CGL009
     C                   MOVEA     L72           FONT72                                        CGL00
      *                                                                   CGL009
      *  Unwind subroutine stack name                                     CGL009
      *                                                                   CGL009
     C     EXDE72        TAG                                                                   CGL00
     C                   MOVEA     *BLANKS       @STK(Q)                                       CGL00
     C                   SUB       1             Q                                             CGL00
      *                                                                   CGL009
     CSR                 ENDSR                                                                 CGL00
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRMAP    : Map Extracted Message Details to Parameters       *
      *                                                               *
      *  CALLED BY: SRPFIL - Read Files for Part Nos/Tags             *
      *                                                               *
      *  CALLS    :        -                                          *
      *                                                               *
      *****************************************************************
     CSR   SRMAP         BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRMAP '      @STK(Q)
      *
      * Get the Translation information - there may be multiple FT
      * fields related to the tag no.
      *
     C                   MOVEL     CRNWRK        KFNWRK
     C                   MOVEL     CRMTPY        KFMTPY
     C                   MOVEL     SVTAG         KFMTAG
     C     CSW209        IFEQ      'Y'
     C                   MOVEL     SVMSEQ        KFMSQN
     C                   ENDIF
      *
     C                   MOVEL     'A'           xCursor           1                        MD058361
     C*****KYINFM        SETLL     MEINFML1                                                 MD056752
     C*****KYINFM        READE     MEINFML1                               61                MD056752
     C/EXEC SQL                                                                             MD056752
     C+ declare ACursor insensitive scroll cursor for                                       MD056752
     C+ select * from MEINFJW0                                                              MD056752
     C**where*FMNWRK >= :FMNWRK and FMMTPY >= :FMMTPY and FMMSEQ >= :FMMSEQ        MD056752 MD058361
     C****and*FMMTAG >= :FMMTAG and FMRECI = 'D'                                   MD056752 MD058361
     C**order*by FMNWRK, FMMTPY, FMMSEQ, FMTAG, FMFTFD                             MD056752 MD058361
     C+ where FMNWRK  = :KFNWRK and FMMTPY  = :KFMTPY and FMMSEQ  = :KFMSQN                 MD058361
     C+   and FMMTAG  = :KFMTAG and FMRECI = 'D'                                            MD058361
     C+ order by FMNWRK, FMMTPY, FMMSEQ, FMMTAG, FMFTFD                                     MD058361
     C/END-EXEC                                                                             MD056752
                                                                                            MD056752
     C/EXEC SQL                                                                             MD056752
     C+ open ACursor                                                                        MD056752
     C/END-EXEC                                                                             MD056752
                                                                                            MD056752
     C/EXEC SQL                                                                             MD056752
     C+ fetch next from ACursor into :MEINFM                                                MD056752
     C/END-EXEC                                                                             MD056752
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'
     C******IN61         IFEQ      '1'                                                      MD056752
     C     SQLCODE       IFEQ      100                                                      MD056752
     C     KFMSQN        ANDEQ     'A'
     C                   MOVEL     *BLANKS       KFMSQN
     C                   MOVEL     'B'           xCursor                                    MD058361
     C*****KYINFM        SETLL     MEINFML1                                                 MD056752
     C*****KYINFM        READE     MEINFML1                               61                MD056752
     C/EXEC SQL                                                                             MD056752
     C+ declare BCursor insensitive scroll cursor for                                       MD056752
     C+ select * from MEINFJW0                                                              MD056752
     C**where*FMNWRK >= :FMNWRK and FMMTPY >= :FMMTPY and FMMSEQ >= :FMMSEQ        MD056752 MD058361
     C****and*FMMTAG >= :FMMTAG and FMRECI = 'D'                                   MD056752 MD058361
     C**order*by FMNWRK, FMMTPY, FMMSEQ, FMTAG, FMFTFD                             MD056752 MD058361
     C+ where FMNWRK  = :KFNWRK and FMMTPY  = :KFMTPY and FMMSEQ  = :KFMSQN                 MD058361
     C+   and FMMTAG  = :KFMTAG and FMRECI = 'D'                                            MD058361
     C+ order by FMNWRK, FMMTPY, FMMSEQ, FMMTAG, FMFTFD                                     MD058361
     C/END-EXEC                                                                             MD056752
                                                                                            MD056752
     C/EXEC SQL                                                                             MD056752
     C+ open BCursor                                                                        MD056752
     C/END-EXEC                                                                             MD056752
                                                                                            MD056752
     C/EXEC SQL                                                                             MD056752
     C+ fetch next from BCursor into :MEINFM                                                MD056752
     C/END-EXEC                                                                             MD056752
     C                   ENDIF
     C                   ENDIF
      *
      * Read until end of tag no.
      *
     C******IN61         DOWEQ     '0'                                                      MD056752
     C     SQLCODE       DOWEQ     0                                                        MD056752
      *
      * Use the tag no's related field name to determine which
      * part of the parameter data structure is to be updated.
      *
     C                   Z-ADD     1             F                 3 0
     C     FMFTFD        LOOKUP    TFLD(F)                                63
      *                                                                                       CSW209
     C     CSW209        IFEQ      'N'
     C     *IN63         ANDEQ     '1'
     C     F             IFGE      61
     C     F             ANDLE     68
     C                   MOVEL     '0'           *IN63
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CER030
     C     CER031        IFEQ      'N'
     C     F             ANDEQ     69
     C                   MOVE      *OFF          *IN63
     C                   ENDIF
      *
      * Only process if the field was found in the table
      *
     C     *IN63         IFEQ      '1'
     C*********************MOVELTPRM,F    PRMDS   4                              CFT006
     C                   MOVEL     TPRM(F)       PRMDS             5
      *
      * Extraction of tags belonging to  part 0 (or sequence A or C)      CFT006
      * of a message                                                      CFT006
     C     KFPART        IFEQ      0                                                           CFT00
      *                                                                   CFT006
     C                   SELECT                                                                CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH21R'                                                     CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH21R         DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH21R                                         CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH51A'                                                     CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH51A         DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH51A                                         CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH30'                                                      CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH30          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH30                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH25 '                                                     CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH25          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH25                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH23 '                                                     CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH23          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH23                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH26T'                                                     CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH26T         DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH26T                                         CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH77B'                                                     CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH77B         DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH77B                                         CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH19 '                                                     CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH19          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH19                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH20 '                                                     CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH20          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH20                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH71G'                                                     CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH71G         DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH71G                                         CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH71F'                                                     CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH71F         DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH71F                                         CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH36 '                                                     CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH36          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH36                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH72 '                                                     CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH72          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH72                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH71'                                                      CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH71          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH71                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH53'                                                      CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH53          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH53                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH54'                                                      CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH54          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH54                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH52'                                                      CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH52          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH52                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH50'                                                      CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH50          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH50                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'PH32A'                                                     CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     PH32A         DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         PH32A                                         CFT00
      *                                                                                       CSW209
     C     PRMDS         WHENEQ    'P103'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     *BLANK        DSOUT
     C                   MOVEL     P103          DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         P103
      *                                                                                       CSW209
     C     PRMDS         WHENEQ    'P108'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     WKDATA        P108
      *                                                                                       CSW209
     C     PRMDS         WHENEQ    'P113'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     WKDATA        P113
      *                                                                                       CSW209
     C     PRMDS         WHENEQ    'P115'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     WKDATA        P115
      *                                                                                       CSW209
     C     PRMDS         WHENEQ    'P119'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     WKDATA        P119
      *                                                                   CFT006
     C                   ENDSL                                                                 CFT00
      *                                                                   CFT006
     C                   ELSE                                                                  CFT00
      * Extraction of tags belonging to  part 1, ..., n of a message      CFT006
      *                                                                   CFT006
     C                   SELECT
      *
      *  Fill value date/Currency/Amount Details using information
      *  from either the Part No. record, or, if values do not exist
      *  use the data from the Control file
      *
     C     PRMDS         WHENEQ    'PDCA'
      *
     C     KYINMP        CHAIN     MEINMPL1                           90
      *
     C     MPSVDT        IFNE      *BLANKS
     C                   MOVEL     MPSVDT        TVVDAT
     C                   ELSE
     C                   MOVEL     CRSVDT        TVVDAT
     C                   END
      *
     C     MPCYCD        IFNE      *BLANKS
     C                   MOVEL     MPCYCD        TVCCY
     C                   ELSE
     C                   MOVEL     CRCYCD        TVCCY
     C                   END
      *
     C     MPAMTS        IFNE      *BLANKS
     C**********           MOVELMPAMTS    TVAMT                           172911
     C                   MOVEL     MPAMTS        TVAMT1           16                           17291
     C                   ELSE
     C**********           MOVELCRAMTS    TVAMT                           172911
     C                   MOVEL     CRAMTS        TVAMT1           16                           17291
     C                   END
     C*                                                                   172911
     C                   MOVEA     TVAMT1        TVAA                                          17291
     C     TVAA(1)       IFEQ      '0'                                                         17291
     C     TVAA(2)       ANDNE     ','                                                         17291
     C                   MOVE      TVAMT1        TVAMT                                         17291
     C                   ELSE                                                                  17291
     C                   MOVEL     TVAMT1        TVAMT                                         17291
     C                   END                                                                   17291
     C/COPY WNCPYSRC,ME1100C003
      *
     C                   MOVEL     DSTRAN        PDCA
      *
     C     PRMDS         WHENEQ    'P20 '
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     P20           DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         P20
      *
     C     PRMDS         WHENEQ    'P21 '
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     P21           DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         P21
      *
     C     PRMDS         WHENEQ    'P50 '
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     P50           DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         P50
      *
     C     PRMDS         WHENEQ    'P52 '
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     P52           DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         P52
      *
     C     PRMDS         WHENEQ    'P53 '
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     P53           DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         P53
      *
     C     PRMDS         WHENEQ    'P54 '
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     P54           DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         P54
      *                                                                   CFT014
     C     PRMDS         WHENEQ    'P55 '                                                      CFT01
     C                   MOVEL     DSTRAN        DSIN                                          CFT01
     C                   MOVEL     *BLANK        DSOUT                                         CFT01
     C                   MOVEL     P55           DSOUT                                         CFT01
     C                   EXSR      SRFILL                                                      CFT01
     C                   MOVEL     DSOUT         P55                                           CFT01
      *
     C     PRMDS         WHENEQ    'P56 '
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     P56           DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         P56
      *
     C     PRMDS         WHENEQ    'P57 '
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     P57           DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         P57
      *
     C     PRMDS         WHENEQ    'P58 '
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     P58           DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         P58
      *
     C     PRMDS         WHENEQ    'P59 '
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     P59           DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         P59
      *
     C     PRMDS         WHENEQ    'P70 '
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     P70           DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         P70
      *                                                                                       CER030
     C     PRMDS         WHENEQ    'PEXN'
      *                                                                                       CER030
     C     CER031        IFEQ      'Y'
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     *BLANKS       DSOUT
     C                   MOVEL     PEXN          DSOUT
     C                   MOVEL     'PEXN'        OTTAG
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         PEXN
     C                   ENDIF
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'P26T'                                                      CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     P26T          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         P26T                                          CFT00
      *
     C     PRMDS         WHENEQ    'P71 '
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     P71           DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         P71
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'P50L'                                                      CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     P50L          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         P50L                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'P21F'                                                      CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     P21F          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         P21F                                          CFT00
      *                                                                   CFT014
     C     PRMDS         WHENEQ    'P23B'                                                      CFT01
     C                   MOVEL     DSTRAN        DSIN                                          CFT01
     C                   MOVEL     *BLANK        DSOUT                                         CFT01
     C                   MOVEL     P23B          DSOUT                                         CFT01
     C                   EXSR      SRFILL                                                      CFT01
     C                   MOVEL     DSOUT         P23B                                          CFT01
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'P23E'                                                      CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     P23E          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         P23E                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'P77B'                                                      CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     P77B          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         P77B                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'P33B'                                                      CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     P33B          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         P33B                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'P25A'                                                      CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     P25A          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         P25A                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'P36 '                                                      CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     P36           DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         P36                                           CFT00
      *                                                                   CFT014
     C     PRMDS         WHENEQ    'P71FX'                                                     CFT01
     C                   MOVEL     DSTRAN        DSIN                                          CFT01
     C                   MOVEL     *BLANK        DSOUT                                         CFT01
     C                   MOVEL     P71FX         DSOUT                                         CFT01
     C                   EXSR      SRFILL                                                      CFT01
     C                   MOVEL     DSOUT         P71FX                                         CFT01
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'P71F'                                                      CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     P71F          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         P71F                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'P71G'                                                      CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     P71G          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         P71G                                          CFT00
      *                                                                   CFT006
     C     PRMDS         WHENEQ    'P32B'                                                      CFT00
     C                   MOVEL     DSTRAN        DSIN                                          CFT00
     C                   MOVEL     *BLANK        DSOUT                                         CFT00
     C                   MOVEL     P32B          DSOUT                                         CFT00
     C                   EXSR      SRFILL                                                      CFT00
     C                   MOVEL     DSOUT         P32B                                          CFT00
      *                                                                                       CSW209
     C     PRMDS         WHENEQ    'PB50'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     *BLANK        DSOUT
     C                   MOVEL     PB50          DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         PB50
      *                                                                                       CSW209
     C     PRMDS         WHENEQ    'PB52'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     *BLANK        DSOUT
     C                   MOVEL     PB52          DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         PB52
      *                                                                                       CSW209
     C     PRMDS         WHENEQ    'PB56'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     *BLANK        DSOUT
     C                   MOVEL     PB56          DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         PB56
      *                                                                                       CSW209
     C     PRMDS         WHENEQ    'PB57'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     *BLANK        DSOUT
     C                   MOVEL     PB57          DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         PB57
      *                                                                                       CSW209
     C     PRMDS         WHENEQ    'PB59'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     *BLANK        DSOUT
     C                   MOVEL     PB59          DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         PB59
      *                                                                                       CSW209
     C     PRMDS         WHENEQ    'PB70'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     *BLANK        DSOUT
     C                   MOVEL     PB70          DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         PB70
      *                                                                                       CSW209
     C     PRMDS         WHENEQ    'PB72'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     *BLANK        DSOUT
     C                   MOVEL     PB72          DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         PB72
      *                                                                                       CSW209
     C     PRMDS         WHENEQ    'PB33B'
     C     CSW209        ANDEQ     'Y'
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     *BLANK        DSOUT
     C                   MOVEL     PB33B         DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         PB33B
      *
     C     PRMDS         WHENEQ    'P72 '
     C                   SELECT                                                                CGL00
      * FONTIS network                                                    CGL009
      * --------------                                                    CGL009
     C     PNWRK         WHENEQ    'FONTIS'                                                    CGL00
      ** DSTRAN and DSFONT have not the same structure (translation       CGL009
      ** field is missing), therefore we move the fields individually     CGL009
     C     DSTRAN        IFNE      *BLANK                                                      CGL00
     C                   MOVEL     TRTAG         FNTAG                                         CGL00
     C                   MOVEL     TRTYPE        FNTYPE                                        CGL00
     C                   MOVEL     TMLIN1        FN72L1                                        CGL00
     C                   MOVEL     TMLIN2        FN72L2                                        CGL00
     C                   MOVEL     TMLIN3        FN72L3                                        CGL00
     C                   MOVEL     TMLIN4        FN72L4                                        CGL00
     C                   MOVEL     TMLIN5        FN72L5                                        CGL00
     C                   MOVEL     TMLIN6        FN72L6                                        CGL00
     C                   ENDIF                                                                 CGL00
     C                   MOVEL     DSFONT        DSIN72                                        CGL00
     C                   MOVEL     P72           DSOT72                                        CGL00
     C                   EXSR      SRFI72                                                      CGL00
     C                   MOVEL     DSOT72        P72                                           CGL00
      * Other networks                                                    CGL009
      * --------------                                                    CGL009
     C                   OTHER                                                                 CGL00
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     P72           DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         P72
     C                   ENDSL                                                                 CGL00
      *
     C     PRMDS         WHENEQ    'PSN '
     C                   MOVEL     DSTRAN        DSIN
     C                   MOVEL     PSN           DSOUT
     C                   EXSR      SRFILL
     C                   MOVEL     DSOUT         PSN
      *
      **  Fill date/currency/amount from the data itself                  CRT002
      *                                                                   CRT002
     C     PRMDS         WHENEQ    'SDCA'                                                      CRT00
      *                                                                   CRT002
     C                   SELECT                                                                CRT00
      *                                                                   CRT002
     C     SVTAG         WHENEQ    'CDATE'                                                     CRT00
      *                                                                   CRT002
      **  Extract the value date from CDATE tag and place in SDCA         CRT002
      *                                                                   CRT002
     C                   MOVEL     SDCA          DSTRAN                                        CRT00
     C                   MOVEL     WKDATA        TVVDAT                                        CRT00
     C                   MOVEL     DSTRAN        SDCA                                          CRT00
      *                                                                   CRT002
     C     SVTAG         WHENEQ    'CDCCY'                                                     CRT00
     C                   MOVEL     *BLANKS       WLIN             25                           CRT00
     C                   MOVEL     TMLIN         WLIN                                          CRT00
     C                   MOVEL     SDCA          DSTRAN                                        CRT00
     C                   MOVEL     SVTAG         TRTAG                                         CRT00
     C                   MOVEL     *BLANKS       TRCODE                                        CRT00
      *                                                                   CRT002
      **  Access field tag file to get the format type                    CRT002
      *                                                                   CRT002
     C                   MOVEL     SVTAG         KMTAG                                         CRT00
     C                   MOVEL     'ALL'         KMTPY                                         CRT00
     C*****KYMTAG        CHAIN     SDMTAGL0                           98              CRT00 MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :KMTAG and EFMTPY = :KMTPY                                           MD056560
     C/END-EXEC                                                                             MD056560
      *                                                                   CRT002
      **  If description found, fill date, currency or amount based on    CRT002
      **  format type                                                     CRT002
      *                                                                   CRT002
     C******IN98         IFEQ      '0'                                                CRT00 MD056560
     C                   IF        SQLCODE = 0                                              MD056560
      *                                                                   CRT002
     C                   SELECT                                                                CRT00
      *                                                                   CRT002
     C     EFTAGF        WHENEQ    'D'                                                         CRT00
     C     6             SUBST     WLIN:1        WVDAT             6                           CRT00
     C                   MOVEL     WVDAT         TVVDAT                                        CRT00
      *                                                                   CRT002
     C     EFTAGF        WHENEQ    'CA'                                                        CRT00
     C     3             SUBST     WLIN:1        TVCCY                                         CRT00
     C     15            SUBST     WLIN:4        TVAMT                                         CRT00
     C/COPY WNCPYSRC,ME1100C004
      *                                                                   CRT002
     C     EFTAGF        WHENEQ    'DCA'                                                       CRT00
     C     6             SUBST     WLIN:1        WVDAT                                         CRT00
     C                   MOVEL     WVDAT         TVVDAT                                        CRT00
     C     3             SUBST     WLIN:7        TVCCY                                         CRT00
     C     15            SUBST     WLIN:10       TVAMT                                         CRT00
     C/COPY WNCPYSRC,ME1100C014
      *                                                                   CRT002
     C                   ENDSL                                                                 CRT00
     C/COPY WNCPYSRC,ME1100C005
      *                                                                   CRT002
     C                   END                                                                   CRT00
      *                                                                   CRT002
     C                   MOVEL     DSTRAN        SDCA                                          CRT00
      *                                                                   CRT002
     C                   ENDSL                                                                 CRT00
      *                                                                   CRT002
      **  Fill date/currency/amount from the data itself                  CRT002
      *                                                                   CRT002
     C     PRMDS         WHENEQ    'PDC2'                                                      CRT00
      *                                                                   CRT002
     C                   SELECT                                                                CRT00
      *                                                                   CRT002
     C     SVTAG         WHENEQ    'CDATE'                                                     CRT00
     C     PMTPY         ANDEQ     'DIA'                                                       CRT00
      *                                                                   CRT002
      **  Extract the value date from CDATE tag and place in PDC2         CRT002
      *                                                                   CRT002
     C                   MOVEL     PDC2          DSTRAN                                        CRT00
     C                   MOVEL     WKDATA        TVVDAT                                        CRT00
     C                   MOVEL     DSTRAN        PDC2                                          CRT00
      *                                                                   CRT002
     C     SVTAG         WHENEQ    'CFCCY'                                                     CRT00
      *                                                                   CRT002
     C                   MOVEL     *BLANKS       WLIN                                          CRT00
     C                   MOVEL     TMLIN         WLIN                                          CRT00
     C                   MOVEL     PDC2          DSTRAN                                        CRT00
     C                   MOVEL     SVTAG         TRTAG                                         CRT00
     C                   MOVEL     *BLANKS       TRCODE                                        CRT00
      *                                                                   CRT002
      **  Access field tag file to get the format type                    CRT002
      *                                                                   CRT002
     C                   MOVEL     SVTAG         KMTAG                                         CRT00
     C                   MOVEL     'ALL'         KMTPY                                         CRT00
     C*****KYMTAG        CHAIN     SDMTAGL0                           98              CRT00 MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :KMTAG and EFMTPY = :KMTPY                                           MD056560
     C/END-EXEC                                                                             MD056560
      *                                                                   CRT002
      **  If description found, fill date, currency or amount based on    CRT002
      **  format type                                                     CRT002
      *                                                                   CRT002
     C******IN98         IFEQ      '0'                                                CRT00 MD056560
     C                   IF        SQLCODE = 0                                        CRT00 MD056560
      *                                                                   CRT002
     C                   SELECT                                                                CRT00
      *                                                                   CRT002
     C     EFTAGF        WHENEQ    'D'                                                         CRT00
     C     6             SUBST     WLIN:1        WVDAT                                         CRT00
     C                   MOVEL     WVDAT         TVVDAT                                        CRT00
      *                                                                   CRT002
     C     EFTAGF        WHENEQ    'CA'                                                        CRT00
     C     3             SUBST     WLIN:1        TVCCY                                         CRT00
     C     15            SUBST     WLIN:4        TVAMT                                         CRT00
     C/COPY WNCPYSRC,ME1100C006
      *                                                                   CRT002
     C     EFTAGF        WHENEQ    'DCA'                                                       CRT00
     C     6             SUBST     WLIN:1        WVDAT                                         CRT00
     C                   MOVEL     WVDAT         TVVDAT                                        CRT00
     C     3             SUBST     WLIN:7        TVCCY                                         CRT00
     C     15            SUBST     WLIN:10       TVAMT                                         CRT00
     C/COPY WNCPYSRC,ME1100C007
      *                                                                   CRT002
     C                   ENDSL                                                                 CRT00
      *                                                                   CRT002
     C                   END                                                                   CRT00
      *                                                                   CRT002
     C                   MOVEL     DSTRAN        PDC2                                          CRT00
      *                                                                   CRT002
     C                   ENDSL                                                                 CRT00
      *                                                                   CRT002
     C     PRMDS         WHENEQ    'CASH'                                                      CRT00
      *                                                                   CRT002
     C                   MOVEL     CASH          DSTRAN                                        CRT00
     C                   MOVEL     SVTAG         TRTAG                                         CRT00
     C                   MOVEL     *BLANKS       TRCODE                                        CRT00
      *                                                                   CRT002
     C                   SELECT                                                                CRT00
      *                                                                   CRT002
     C     SVTAG         WHENEQ    'CUSER'                                                     CRT00
     C                   MOVEL     WKDATA        TUSER                                         CRT00
      *                                                                   CRT002
     C     SVTAG         WHENEQ    'CTRAN'                                                     CRT00
     C                   MOVEL     WKDATA        TTRAN                                         CRT00
      *                                                                   CRT002
     C     SVTAG         WHENEQ    'CSPCD'                                                     CRT00
     C                   MOVEL     WKDATA        TSPCD                                         CRT00
      *                                                                   CRT002
     C     SVTAG         WHENEQ    'CPOST'                                                     CRT00
     C                   MOVEL     WKDATA        TPOST                                         CRT00
      *                                                                   CRT002
     C     SVTAG         WHENEQ    'CHOST'                                                     CRT00
     C                   MOVEL     WKDATA        THOST                                         CRT00
      *                                                                   CRT002
     C     SVTAG         WHENEQ    'CWKID'                                                     CRT00
     C                   MOVEL     WKDATA        TWKID                                         CRT00
      *                                                                   CRT002
     C                   ENDSL                                                                 CRT00
      *                                                                   CRT002
     C                   MOVEL     DSTRAN        CASH                                          CRT00
      *                                                                   CRT002
     C                   ENDSL
      *
     C                   END
      *
      *  /Copy point for Mapping
      *
     C/COPY WNCPYSRC,ME1100DMAP
      *                                                                   CFT006
     C                   ENDIF                                                                 CFT00
      *
      * Check if another record to be read
      *
     C*****KYINFM        READE     MEINFML1                               61                MD056752
     C*****KFMSQN        IFEQ      *BLANKS                                         MD056752 MD058361
     C     xCursor       IFEQ      'B'                                                      MD058361
     C/EXEC SQL                                                                             MD056752
     C+ fetch next from BCursor into :MEINFM                                                MD056752
     C/END-EXEC                                                                             MD056752
     C                   ELSE                                                               MD056752
     C/EXEC SQL                                                                             MD056752
     C+ fetch next from ACursor into :MEINFM                                                MD056752
     C/END-EXEC                                                                             MD056752
     C                   ENDIF                                                              MD056752
      *
     C                   ENDDO
     C/COPY WNCPYSRC,ME1100C002
      *
     C     xCursor       IFEQ      'B'                                                      MD058361
     C/EXEC SQL                                                                             MD058361
     C+ close BCursor                                                                       MD058361
     C/END-EXEC                                                                             MD058361
     C                   ELSE                                                               MD058361
     C/EXEC SQL                                                                             MD058361
     C+ close ACursor                                                                       MD058361
     C/END-EXEC                                                                             MD058361
     C                   ENDIF                                                              MD058361
      * Initialise fields
      *
     C                   CLEAR                   DSTRAN
     C                   Z-ADD     0             L
     C                   MOVEL     *BLANKS       LIN
     C                   CLEAR                   DSFONT
     C                   Z-ADD     1             B
     C                   MOVEL     *BLANKS       L72
      *
      *  Unwind subroutine stack name
      *
     C     EXMAP         TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRFILL   : Fill Data Structure fields                        *
      *                                                               *
      *  CALLED BY: SRMAP  - Map Extracted Message Details to Paramet *
      *                                                               *
      *  CALLS    :        -                                          *
      *                                                               *
      *****************************************************************
     CSR   SRFILL        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRFILL'      @STK(Q)
      *
      *  Update tag information if not already present
      *
     C     OTTAG         IFEQ      *BLANKS
     C                   MOVEL     INTAG         OTTAG
     C                   MOVEL     INTYPE        OTTYPE
     C                   MOVEL     INCODE        OTCODE
     C                   END
      *
      *  Fill multiple line details
      *
      *  For each line in the Tag's details, move it to the next
      *  available line in the parameter data structure. The maximum
      *  no. of lines to move is stored in 'L', the counter used when
      *  extracting the tag's detail lines.
      *
     C                   Z-ADD     0             Y                 2 0
     C                   Z-ADD     0             X                 2 0
      *
     C     X             DOUEQ     6
     C                   ADD       1             X
      *
     C     OUT(X)        IFEQ      *BLANKS
     C                   LEAVE
     C                   END
      *
     C                   ENDDO
      *
     C     X             IFEQ      6
     C     OUT(X)        ANDNE     *BLANKS
     C                   GOTO      EXFILL
     C                   END
      *
      *  Fill remainder of OUT array with the new data
      *
     C     Y             DOUEQ     L
     C     X             OREQ      7
     C                   ADD       1             Y
      *
     C                   MOVEL     IN(Y)         OUT(X)
     C                   ADD       1             X
      *
     C                   ENDDO
      *
      *  Unwind subroutine stack name
      *
     C     EXFILL        TAG
      *
      *  Hook to process the output data structure
     C/COPY WNCPYSRC,ME1100PODS
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT                                                              CGL009
      *****************************************************************   CGL009
      *                                                               *   CGL009
      *  SRFI72   : Fill Data Structure fields for tag :72: (FONTIS)  *   CGL009
      *                                                               *   CGL009
      *  CALLED BY: SRMAP  - Map Extracted Message Details to Paramet *   CGL009
      *                                                               *   CGL009
      *  CALLS    :        -                                          *   CGL009
      *                                                               *   CGL009
      *****************************************************************   CGL009
     CSR   SRFI72        BEGSR                                                                 CGL00
      *                                                                   CGL009
      *  Set up subroutine stack name                                     CGL009
      *                                                                   CGL009
     C                   ADD       1             Q                                             CGL00
     C                   MOVEL     'SRFI72'      @STK(Q)                                       CGL00
      *                                                                   CGL009
      *  Update tag information if not already present                    CGL009
      *                                                                   CGL009
     C     O72TAG        IFEQ      *BLANKS                                                     CGL00
     C                   MOVEL     I72TAG        O72TAG                                        CGL00
     C                   MOVEL     I72TYP        O72TYP                                        CGL00
     C                   END                                                                   CGL00
      *                                                                   CGL009
      *  Fill multiple line details                                       CGL009
      *                                                                   CGL009
      *  For each line in the Tag's details, move it to the next          CGL009
      *  available line in the parameter data structure. The maximum      CGL009
      *  no. of lines to move is stored in 'L', the counter used when     CGL009
      *  extracting the tag's detail lines.                               CGL009
      *                                                                   CGL009
     C                   Z-ADD     0             X                 2 0                         CGL00
     C                   Z-ADD     1             P                 3 0                         CGL00
      *                                                                   CGL009
     C     X             DOUEQ     6                                                           CGL00
     C                   ADD       1             X                                             CGL00
      *                                                                   CGL009
     C     OT72(P)       IFEQ      *BLANKS                                                     CGL00
     C                   LEAVE                                                                 CGL00
     C                   END                                                                   CGL00
     C     X             IFEQ      1                                                           CGL00
     C*********************ADD  65        P                         CGL009175479
     C                   ADD       100           P                                             17547
     C                   ELSE                                                                  CGL00
     C                   ADD       35            P                                             CGL00
     C                   END                                                                   CGL00
      *                                                                   CGL009
     C                   ENDDO                                                                 CGL00
      *                                                                   CGL009
     C***********P         IFGT 240                                 CGL009175479
     C     P             IFGT      250                                                         17547
     C                   GOTO      EXFI72                                                      CGL00
     C                   END                                                                   CGL00
      *                                                                   CGL009
      *  Fill remainder of OUT array with the new data                    CGL009
      *                                                                   CGL009
      *                                                                   CGL009
     C     X             IFEQ      1                                                           CGL00
     C                   MOVEA     IN72(1)       OT72(P)                                       CGL00
     C                   ELSE                                                                  CGL00
      ***When*72*has*been*already*filled,*the*first*line*(65*chars)*CGL009175479
      ** When 72 has been already filled, the first line (100 chars)      175479
      ** is busy, so we assume the remaining lines is 35 char long        CGL009
      ** each.                                                            CGL009
      *                                                                   CGL009
      ** For instance as translations, we have defined                    CGL009
      ** :59: ----> BANKTOBANK                                            CGL009
      ** :72: ----> BANKTOBANK                                            CGL009
      *                                                                   CGL009
      ** The first line of 59 will fill the field with 65 chars           CGL009
      ** the remaining lines will fill the other fields (35 chars each)   CGL009
      *                                                                   CGL009
      ***If*the*first*line*of*:72:*is*65*chars*long,*it*will*be**** CGL009175479
      ** If the first line of :72: is 100 chars long, it will be          175479
      ** truncated                                                        CGL009
      ** If the first line of :72: is 35 chars long, it will be           CGL009
      ** appened without any lost of chars.                               CGL009
      ** Notice :                                                         CGL009
      ***Field*IN72*is*defined*as*65*+*35x5                         CGL009175479
      ** Field IN72 is defined as 100 + 35x5                              175479
      **                                                                  CGL009
     C                   MOVEA     IN72(1)       W35              35                           CGL00
     C                   MOVEA     W35           OT72(P)                                       CGL00
     C                   ADD       35            P                                             CGL00
     C***********P         IFLE 240                                 CGL009175479
     C     P             IFLE      250                                                         17547
     C*********************MOVEAIN72,66   OT72,P                    CGL009175479
     C                   MOVEA     IN72(101)     OT72(P)                                       17547
     C                   END                                                                   CGL00
     C                   END                                                                   CGL00
      *                                                                   CGL009
      *  Unwind subroutine stack name                                     CGL009
      *                                                                   CGL009
     C     EXFI72        TAG                                                                   CGL00
     C                   MOVEA     *BLANKS       @STK(Q)                                       CGL00
     C                   SUB       1             Q                                             CGL00
      *                                                                   CGL009
     CSR                 ENDSR                                                                 CGL00
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRACT    : Undefined action - error                          *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRACT         BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRACT '      @STK(Q)
      *
      *  Database error undefined action
      *
     C                   MOVEL     '*ACTION '    W0FILE                         ***************
     C                   MOVEL     W0ACT         W0KEY                          * DB ERROR 03 *
     C                   Z-ADD     2             W0ERNB                         ***************
     C                   MOVEL     'MEM5006'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
      *
      *  Unwind subroutine stack name
      *
     C     EXACT         TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    :        -                                          *
      *                                                               *
      *****************************************************************
     CSR   SRINIT        BEGSR
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          BIS@             80
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *  Define fields
      *
     C     *LIKE         DEFINE    CRNWRK        KFNWRK
     C     *LIKE         DEFINE    CRMTPY        KFMTPY
     C     *LIKE         DEFINE    DTMTG         KFMTAG
      *
     C     *LIKE         DEFINE    DTMSGR        KFMSGR
     C     *LIKE         DEFINE    DTPART        KFPART
     C     *LIKE         DEFINE    DTMTG         KFTAG
     C     *LIKE         DEFINE    DTSEQN        KFSEQ
      *
     C     *LIKE         DEFINE    DTMFLD        WKDATA
     C     *LIKE         DEFINE    DTMTG         SVTAG
     C     *LIKE         DEFINE    DTMSEQ        KFMSEQ
     C     *LIKE         DEFINE    FMMSEQ        KFMSQN
     C     *LIKE         DEFINE    DTMSEQ        SVMSEQ
      *
      * Set keylist for Incoming Message Translation File
      *
     C     KYINFM        KLIST
     C                   KFLD                    KFNWRK
     C                   KFLD                    KFMTPY
     C                   KFLD                    KFMSQN
     C                   KFLD                    KFMTAG
      *
      * Set keylist for Incoming Message Detail Multi Format file
      *
     C     KYINDT        KLIST
     C                   KFLD                    KFMSGR
     C                   KFLD                    KFPART
     C                   KFLD                    KFTAG
     C                   KFLD                    KFMSEQ
     C                   KFLD                    KFSEQ
      *
      * Set keylist for Incoming Message Part No. File
      *
     C     KYINMP        KLIST
     C                   KFLD                    PHMSGR
     C                   KFLD                    PHPART
      *                                                                   CRT002
      **  Define key list for SDMTAGL0                                    CRT002
      *                                                                   CRT002
     C     KYMTAG        KLIST                                                                 CRT00
     C                   KFLD                    KMTAG             5                           CRT00
     C                   KFLD                    KMTPY             3                           CRT00
      *
      * Open Files
      *
     C                   OPEN      MEINCRL1
     C                   OPEN      MEINMPL1
     C                   OPEN      MEINDTS2
     C**********         OPEN      MEINFML1                                                 MD056752
     C**********         OPEN      SDMTAGL0                                           CRT00 MD056560
      *
      *  Get Rundate information
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
     C/COPY WNCPYSRC,ME1100C011
      *                                                                                       CSW209
      ** Check if SWIFT2009 is installed                                                      CSW209
      *                                                                                       CSW209
     C                   MOVEL     'N'           CSW209            1
     C                   CALL      'SWIF2009'
     C                   PARM      *BLANKS       PRTCD             7
      *                                                                                       CSW209
     C     PRTCD         IFEQ      'CSW2009'
     C                   MOVEL     'Y'           CSW209
     C                   ENDIF
      *
      *  Indicate that set up is complete
      *
     C                   SETON                                        50
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C/COPY WNCPYSRC,ME1100C008
      *                                                                                       CSC022
      ** Check if CSC022 is switched *ON.                                                     CSC022
      *                                                                                       CSC022
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSC022'      @SARD             6
      *                                                                                       CSC022
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC022            1
     C     *DTAARA       DEFINE    SCCMTJOB      SCCMT
     C                   IN        SCCMT
     C                   Z-ADD     1             C                 3 0
     C                   MOVEL     *BLANKS       WCMTSK            1
     C                   MOVEA     CMTARR        CMTJOB
     C     CMTNUM        IFGT      0
     C     C             DOWLE     CMTNUM
     C     ##JOB         IFEQ      CMTJOB(C)
     C                   MOVEL     'Y'           WCMTSK
     C                   ENDIF
     C                   ADD       1             C
     C                   ENDDO
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           CSC022
     C                   ENDIF
      *                                                                                       CER030
      ** Check the switchable feature CER031                                                  CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*VERIFY'     POPTN             7
     C                   PARM      'CER031'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *                                                                                       CER030
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CER031            1
     C                   ELSE
     C                   MOVEL     'N'           CER031
     C                   ENDIF
      *
     CSR                 ENDSR
     C/EJECT
     C/COPY WNCPYSRC,ME1100DCPG
      *
      *  /Copy point for Calculation Specs
      *
     C/EJECT
     C*COPY*MECPYSRC,SRERRC                                                                 MD056560
     C/COPY MECPYSRC,SRERRCLE                                                               MD056560
     C/EJECT
     C/COPY WNCPYSRC,ME1100DOPG
      *
      *  /Copy point for Output Specs
      *
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA TFLD
DTCYAMT :HPH32A                                                           CFT006
DATECCYAMTPDCA
SNDR ADDR PSN
TRAN REF  P20
RELATE REFP21
ORD CUST:HPH50                                                            CFT006
ORDER CUSTP50
ORD BANK:HPH52                                                            CFT006
ORDER BANKP52
SND CORR:HPH53                                                            CFT006
SNDR CORR P53
RCV CORR:HPH54                                                            CFT006
RECV CORR P54
THIRD REIMP55                                                             CFT014
INTERMEDY P56
ACC INST  P57
BENF INST P58
BENF CUST P59
PAY DETLS P70
TRAN CODE P26T                                                            CFT006
PAY CHGS:HPH71                                                            CFT006
PAY CHGS  P71
BNKTOBNK:HPH72                                                            CFT006
BANKTOBANKP72
CASHIER   CASH                                                            CRT002
DATECYAMT1PDC2                                                            CRT002
DATECYAMT2SDCA                                                            CRT002
INST PTY:HPH50L                                                           CFT006
INSTR PTY P50L                                                            CFT006
ACSRVINS:HPH52                                                            CFT006
AC SRV IN P52                                                             CFT006
FX REF    P21F                                                            CFT006
INSTR CODEP23E                                                            CFT006
BANK OPCD P23B                                                            CFT014
REG REPR:HPH77B                                                           CFT006
REG REPRT P77B                                                            CFT006
ORIGCCYAMTP33B                                                            CFT006
CHGS ACC  P25A                                                            CFT006
FX RATE :HPH36                                                            CFT006
FX RATE   P36                                                             CFT006
SEND CHG:HPH71F                                                           CFT006
SEND CHG  P71F                                                            CFT006
SND CHG*  P71FX                                                           CFT014
RECV CHG:HPH71G                                                           CFT006
RECV CHG  P71G                                                            CFT006
CCYAMT    P32B                                                            CFT006
CUST REF:HPH21R                                                           CFT006
SNDR IN :HPH51A                                                           CFT006
EXEC DT :HPH30                                                            CFT006
AUTHRSN :HPH25                                                            CFT006
BANK OPC:HPH23                                                            CFT006
TRAN COD:HPH26T                                                           CFT006
SUM TOT :HPH19                                                            CFT006
FILE REF:HPH20                                                            CFT006
SNDR REF:HPH20                                                            CFT006
FIN COPY  P103                                                                                CSW209
MUR       P108                                                                                CSW209
BANK PTY  P113                                                                                CSW209
ADDL INFO P115                                                                                CSW209
VALID FLAGP119                                                                                CSW209
ORDER CU:BPB50                                                                                CSW209
ORDER BK:BPB52                                                                                CSW209
INTERMED:BPB56                                                                                CSW209
ACC INST:BPB57                                                                                CSW209
BENFCUST:BPB59                                                                                CSW209
PAY DETL:BPB70                                                                                CSW209
BNKTOBNK:BPB72                                                                                CSW209
ORGCCYAM:BPB33B                                                                               CSW209
EXT NARR  PEXN                                                                                CER030
