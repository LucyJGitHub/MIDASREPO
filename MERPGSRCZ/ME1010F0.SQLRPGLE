     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD056560
/*STD *  RPGSQLBND                                                    *                     MD056560
/*EXI *  TEXT('Midas ME Format incoming message line')
     F*****************************************************************
     F*                                                               *
     F*  Midas - Message Management Module
     F*                                                               *
     F*  ME1010F0 - Format Incoming Message Information               *
     F*                                                               *
     F*  Function:  This program                                      *
     F*                                                               *
     F*                                                               *
     F*  Called By: ME1140  - Print IMM Transaction Details           *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD056560           Date 31Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CSW097             Date 26May97               *
      *                 CRT002             Date  1Dec95               *
     F*                 094636             Date 14Oct95               *
     F*                 069250             DATE 03MAY94               *
     F*                 S01435             DATE 29JUL93               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD056560 - Deliverable Data Split for SDMTAGPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
     F*  CSW097 - Swift changes 1997:                                 *
     F*           The program was amended to recognise dates          *
     F*           in CCYYMMDD format.                                 *
     F*  CRT002 - Retail Branch Access.                               *
     F*  094636 - The pgm does not consider the field tag of length   *
     F*           > 50 but less than 100.  The presentation of this   *
     F*           field is quite difficult to read.                   *
     F*           44A: Shipment Details Format A                      *
     F*           44B: Shipment Details Format B                      *
     F*           44D: Shipment Details Format D                      *
     F*           45A: Description of Goods and/or Service Format A   *
     F*           45B: Description of Goods and/or Service Format B   *
     F*           46A: Documents Required Format A                    *
     F*           46B: Documents Required Format B                    *
     F*           47A: Additional Conditions Format A                 *
     F*           47B: Additional Conditions Format B                 *
     F*           78:  Instruction to Paying/Accepting/Negotiating Bnk*
     F*  069250 - Remove dummy OVRDBF command from creation parms.    *
     F*  S01435 - Incoming Message Management                         *
     F*                                                               *
     F*****************************************************************
     F*  C R E A T I O N     P A R A M E T E R S                      *
     F*                                                               *
/****F*:*OVRDBF*(File*in*program)*(file*on*system)******************:**   069250
     F*****************************************************************
     F*****************************************************************
     F*                                                               *
     F*  Indicator usage                                              *
     F*  ~~~~~~~~~~~~~~~                                              *
     F*                                                               *
     F*  50    First cycle                                            *
     F*  90    General Work Indicator                                 *
     F*  99    EOF on Read                                            *
     F*                                                               *
     F*  U7/U8 Error Ocurred                                          *
     F*  LR    End program                                            *
     F*                                                               *
     F*****************************************************************
     F*SDMTAGL0* IF   E           K DISK    INFSR(SRFILE)                                   MD056560
     F**********                           USROPN                                           MD056560
      *
      *  Message tag
      *
     F/EJECT
     D L65             S              5    DIM(10) CTDATA PERRCD(1)                              094
      *
      *  Copyright table
      *
     D*COPY*MECPYSRC,SRERRE                                                                 MD056560
     D/COPY MECPYSRC,SRERRELE                                                               MD056560
      *
      *  End of Copysource for error processing
      *
     D FLA             S              1    DIM(50)                              Format field
     D FLB             S              1    DIM(50)                              Formatted field
     D #R              S              1    DIM(60)                              Move Right Array
     D #S              S              1    DIM(60)                              Res. Right Array
      *
      *  Arrays for formatting tag line details
      *
      ** Array of Commitment Job Names                                                        CSC022
     D CMTJOB          S             10    DIM(10)
     D/EJECT
     D*COPY*MECPYSRC,SRERRI                                                                 MD056560
     D/COPY MECPYSRC,SRERRILE                                                               MD056560
      *
      *  End of Program Error Processing copysource member
      *
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      *  Define rundat data area
      *
     D CPYR@#          DS
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      /EJECT
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      *  Calling parameter data structure for AOCUSTR0
      *
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      *  Calling parameter data structure for ME1400
      *
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      *
      *  Calling parameter data structure for ME1400
      *
      /EJECT
      *
      * Multiple message part headings for screens
      *
     D                 DS
     D  FORMSC                 1     76
     D**EFSCFD*                1     20                                                     MD056560
     D  XFSCFD                 1     20                                                     MD056560
     D  MTAG                  21     25
     D  MFLD                  27     76
     D  MFLDS1                 1     25                                         094636
     D  MFLDS2                11     76                                         094636
      *
      * Multiple message part headings for reports
      *
     D                 DS
     D  FORMRP                 1    120
     D**EFRPFD*                1     60                                                     MD056560
     D  XFRPFD                 1     60                                                     MD056560
     D  MTAGRP                63     67
     D  MFLDRP                70    119
     D  MFLDR1                 1     67                                         094636
     D  MFLDR2                54    119                                         094636
      *
      * Layout for BIC directory processing
      *
     D BICLAY          DS           120
     D  #DATS                 27     76
     D  #DATR                 70    120
      * Format for Screen
     D  #SCR1                 27     61
     D  #SCR2                 62     76
      * Format for Report
     D  #RPT1                 70    104
     D  #RPT2                105    120
      *
      **  Heading for Message Managemnt free-format messages
      *
     D                 DS
     D  WRKDAT                 1      8
     D  WRKYY                  1      2
     D  WRKMM                  4      5
     D  WRKDD                  7      8
      *
      **  Data structure for rearranging date
      *
     D                 DS
     D  CHGDAT                 1      8
     D  @CHG5                  1      5
     D  @1                     3      3    INZ('/')
     D  @@2                    6      6    INZ('/')
     D  CHGYY                  7      8
      *                                                                   CSW097
      ** New data structure was introduced to accommodate                 CSW097
      ** CCYYMMDD format.                                                 CSW097
      *                                                                   CSW097
     D                 DS                                                       CSW097
     D  WKDAT                  1     10                                         CSW097
     D  WKYY                   1      4                                         CSW097
     D  WKMM                   6      7                                         CSW097
     D  WKDD                   9     10                                         CSW097
      *                                                                   CSW097
      ** Data structure for rearranging date in CCYYMMDD format.          CSW097
      *                                                                   CSW097
     D                 DS                                                       CSW097
     D  CHDAT                  1     10                                         CSW097
     D  @CH5                   1      5                                         CSW097
     D  @3                     3      3    INZ('/')                             CSW097
     D  @@4                    6      6    INZ('/')                             CSW097
     D  CHYY                   7     10                                         CSW097
      *                                                                   CSW097
      ** Define a constant.                                               CSW097
      *                                                                   CSW097
     D DIGITS          C                   CONST('0123456789')                  CSW097
      *
     D DSMTR           DS
      *
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
      *
     D #MSTX2          DS           512
      *
      *  Define fields for extended message
      *
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
     D SCCMT           DS           256
     D  CMTNUM                 1      3  0
     D  CMTARR                 4    103
     D SDMTAG        E DS                  EXTNAME(SDMTGJW0)                                MD056560
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
     C                   PARM                    P0RTN             7
     C                   PARM                    I#NWRK            6            Network
     C                   PARM                    I#MTAG            5            Tag No.
     C                   PARM                    I#MTPY            3            Msg Type
     C                   PARM                    I#FPID            1            1st Line of Tag
     C                   PARM                    I#MFLD          100            Tag Detail Line
     C                   PARM                    O#MDTA           76            Screen Data 1
     C                   PARM                    O#MDT2           76            Screen Data 2
     C                   PARM                    O#MDT3           76            Screen Data 2
     C                   PARM                    O#MDT4           76            Screen Data 2
     C                   PARM                    O#MDT5           76            Screen Data 2
     C                   PARM                    O#RDTA          120            Report Data 1
     C                   PARM                    O#RDT2          120            Report Data 2
     C                   PARM                    O#RDT3          120            Report Data 2
     C                   PARM                    O#RDT4          120            Report Data 2
      *
      *  Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      SRINIT
     C                   END
      *
      *  Write message text
      *
     C                   EXSR      SRTEXT
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
      *  SRTEXT   : Validate contents of Message Reference field      *
      *                                                               *
      *  CALLED BY: Main processing section                           *
      *                                                               *
      *  CALLS    : SRFORM                                            *
      *           : SRSWAD                                            *
      *                                                               *
      *****************************************************************
     CSR   SRTEXT        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRTEXT'      @STK(Q)
      *
      * Initialise to blanks Out data
      *
     C                   MOVEL     *BLANKS       O#MDTA                         Screen
     C                   MOVEL     *BLANKS       O#MDT2                         Screen
     C                   MOVEL     *BLANKS       O#MDT3                         Screen
     C                   MOVEL     *BLANKS       O#MDT4                         Screen
     C                   MOVEL     *BLANKS       O#MDT5                         Screen
     C                   MOVEL     *BLANKS       FORMSC
      *
     C                   MOVEL     *BLANKS       O#RDTA                         Report
     C                   MOVEL     *BLANKS       O#RDT2                         Report
     C                   MOVEL     *BLANKS       O#RDT3                         Report
     C                   MOVEL     *BLANKS       O#RDT4                         Report
     C                   MOVEL     *BLANKS       FORMRP
      *
      * Access field tag file using message tag & type. If a record is
      * not found, try again with for just the tag.
      *
     C                   MOVEL     I#MTAG        MTAGK
     C                   MOVEL     I#MTPY        MTPYK
     C*****MGTGK1        CHAIN     SDMTAGL0                           98                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :MTAGK and EFMTPY = :MTPYK                                           MD056560
     C/END-EXEC                                                                             MD056560
      *
     C******IN98         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     'ALL'         MTPYK
     C*****MGTGK1        CHAIN     SDMTAGL0                           98                    MD056560
     C/EXEC SQL                                                                             MD056560
     C+ SELECT *                                                                            MD056560
     C+ into :SDMTAG                                                                        MD056560
     C+ from SDMTGJW0                                                                       MD056560
     C+ where EFMTAG = :MTAGK and EFMTPY = :MTPYK                                           MD056560
     C/END-EXEC                                                                             MD056560
      *
      * If description not found, set fields with 'No Description' msg
      *
     C******IN98         IFEQ      '1'                                                      MD056560
     C                   IF        SQLCODE = 100                                            MD056560
     C                   MOVEL     ##NODS        EFSCFD                         Screen
     C                   MOVEL     ##NODS        EFRPFD                         Report
     C                   END
      *
     C                   END
     C                   eval      XFSCFD = EFSCFD                                          MD056560
     C                   eval      XFRPFD = EFRPFD                                          MD056560
      *
      *  Get tag and field information
      *
     C     1             SUBST     I#MTAG:2      #WK1              1            Tag No.
     C     1             SUBST     I#MTAG:4      #WK2              1            Tag Format I.D
     C     1             SUBST     I#MFLD:1      #WK3              1            Detail Line
      *
      *  /COPY to allow specific formatting
      *
     C/COPY WNCPYSRC,ME1010F0S1
      *
      *  Call appropriate formatting subroutine
      *
      * If tag format exists
      *
     C                   SELECT
      *
     C     EFTAGF        WHENNE    *BLANKS
     C                   EXSR      SRFORM
      *
      *  If SWIFT address obtain name/town
      *
     C     I#NWRK        WHENEQ    'SWIFT'
     C     #WK1          ANDEQ     '5'
     C     #WK2          ANDEQ     'A'
     C     #WK3          ANDNE     '/'
     C/COPY WNCPYSRC,ME1010F0C1
     C                   MOVEL     I#MFLD        @WK50            50
     C                   EXSR      SRSWAD
      *
     C                   MOVEL     @WK50         MFLD
     C                   MOVEL     @WK50         MFLDRP
      *
      *  Map data
      *
     C                   OTHER
     C                   MOVEL     I#MFLD        MFLD
     C                   MOVEL     I#MFLD        MFLDRP
     C                   ENDSL
      *
      *  Set Tag No./Tag Description fields in data structures
      *
     C                   MOVEL     I#MTAG        MTAG
     C                   MOVEL     I#MTAG        MTAGRP
      *
      *  If not the first line for the tag, clear tag heading fields
      *
     C     I#FPID        IFNE      'F'
     C                   MOVEL     *BLANKS       EFSCFD
     C                   MOVEL     *BLANKS       EFRPFD
     C                   MOVEL     *BLANKS       MTAG
     C                   MOVEL     *BLANKS       MTAGRP
     C                   END
      *
      *  Shift formatted text to right
      *
     C                   EXSR      SRMOVR
      *                                                                   094636
      ** If the field tag contains more than 50 lines, try to show        094636
      ** in the second line.                                              094636
      *                                                                   094636
     C                   Z-ADD     1             A                 2 0                         09463
     C     I#MTAG        LOOKUP    L65(A)                                 53                   09463
     C*                                                                   094636
     C     *IN53         IFEQ      '1'                                                         09463
      *                                                                   094636
      *  Move formatted data structures to parameters                     094636
      *  tag description and tag only.                                    094636
      *                                                                   094636
     C     I#FPID        IFEQ      'F'                                                         09463
      *                                                                   094636
      *  Format first line                                                094636
      *                                                                   094636
     C                   MOVEL     MFLDS1        O#MDTA                         Screen         09463
     C                   MOVEL     MFLDR1        O#RDTA                         Report         09463
      *                                                                   094636
      *  Format second line                                               094636
      *                                                                   094636
     C                   MOVEL     *BLANKS       FORMSC                                        09463
     C                   MOVEL     *BLANKS       FORMRP                                        09463
     C                   MOVEL     I#MFLD        MFLDS2                                        09463
     C                   MOVEL     I#MFLD        MFLDR2                                        09463
     C                   MOVEL     FORMSC        O#MDT2                         Screen         09463
     C                   MOVEL     FORMRP        O#RDT2                         Report         09463
     C                   MOVEL     *BLANKS       FORMSC                                        09463
     C                   MOVEL     *BLANKS       FORMRP                                        09463
      *                                                                   094636
     C                   ELSE                                                                  09463
      *                                                                   094636
      *  Format other lines                                               094636
      *                                                                   094636
     C                   MOVEL     *BLANKS       FORMSC                                        09463
     C                   MOVEL     *BLANKS       FORMRP                                        09463
     C                   MOVEL     I#MFLD        MFLDS2                                        09463
     C                   MOVEL     I#MFLD        MFLDR2                                        09463
     C                   MOVEL     FORMSC        O#MDTA                         Screen         09463
     C                   MOVEL     FORMRP        O#RDTA                         Report         09463
      *                                                                   094636
     C                   END                                                                   09463
      *                                                                   094636
     C                   GOTO      EXTEXT                                                      09463
      *                                                                   094636
     C                   END                                                                   09463
      *
      *  Move formatted data structures to parameters
      *
     C                   MOVEL     FORMSC        O#MDTA                         Screen
     C                   MOVEL     FORMRP        O#RDTA                         Report
      *
      *  Format second line if needed
      *
     C                   MOVE      I#MFLD        @WK50
     C     @WK50         IFNE      *BLANKS
      *
     C                   MOVEL     *BLANKS       EFSCFD
     C                   MOVEL     *BLANKS       EFRPFD
     C                   MOVEL     *BLANKS       MTAG
     C                   MOVEL     *BLANKS       MTAGRP
      *
     C                   MOVE      I#MFLD        MFLD
     C                   MOVE      I#MFLD        MFLDRP
      *
     C                   MOVEL     FORMSC        O#MDT2                         Screen
     C                   MOVEL     FORMRP        O#RDT2                         Report
     C                   END
      *
      *  /COPY to allow specific formatting
      *
     C/COPY WNCPYSRC,ME1010F0S2
      *
      *
      *  Unwind subroutine stack name
      *
     C     EXTEXT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRFORM   : Format subfield                                   *
      *                                                               *
      *  CALLED BY:  SRTEXT write message text                        *
      *                                                               *
      *  CALLS    :                                                   *
      *                                                               *
      *****************************************************************
      *
     CSR   SRFORM        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRFORM'      @STK(Q)
      *
      *  /COPY to allow specific formatting
      *
     C/COPY WNCPYSRC,ME1010F0S3
      *
     C                   MOVEA     I#MFLD        FLA
     C                   MOVE      *BLANKS       FLB
      *
      *  If Tag Format is for Value Date/Currency/Amount
      *  then replace the ',' in the amount with a '.'
      *
     C     EFTAGF        IFEQ      'DCA'                                                   1
     C     EFTAGF        OREQ      'CA'                                                    1
     C     EFTAGF        OREQ      'A'
      *
     C                   Z-ADD     1             A                 2 0
     C     ','           LOOKUP    FLA(A)                                 53
      *
     C     *IN53         IFEQ      '1'                                                     1
     C                   MOVE      '.'           FLA(A)
     C                   END                                                              E1
      *                                                                   CRT002
      **  Format the second amount (Position Amount 2) for                CRT002
      **  message tag CPOST.                                              CRT002
      *                                                                   CRT002
     C     EFMTAG        IFEQ      'CPOST'                                                     CRT00
     C     *IN53         ANDEQ     '1'                                                         CRT00
     C                   ADD       1             A                                             CRT00
     C     ','           LOOKUP    FLA(A)                                 53                   CRT00
     C     *IN53         IFEQ      '1'                                                         CRT00
     C                   MOVE      '.'           FLA(A)                                        CRT00
     C                   END                                                                   CRT00
     C                   END                                                                   CRT00
      *
     C                   END                                                              E1
      *
      *  Format the Date - insert '/'
      *
     C     EFTAGF        IFEQ      'DCA'                                                   1
     C     EFTAGF        OREQ      'D'
     C     DIGITS        CHECK     FLA(7)                                 47                   CSW09
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEA     FLA(1)        @WK2              2
     C                   MOVEA     @WK2          FLB(1)
     C                   MOVE      '/'           FLB(3)
     C                   MOVEA     FLA(3)        @WK2
     C                   MOVEA     @WK2          FLB(4)
     C                   MOVE      '/'           FLB(6)
     C                   MOVEA     FLA(5)        @WK2
     C                   MOVEA     @WK2          FLB(7)
      *
     C                   MOVEA     FLB(1)        WRKDAT
     C                   MOVE      WRKYY         CHGYY
     C                   ELSE                                                                  CSW09
     C                   MOVEA     FLA(1)        @WK4              4                           CSW09
     C                   MOVEA     @WK4          FLB(1)                                        CSW09
     C                   MOVEA     '/'           FLB(5)                                        CSW09
     C                   MOVEA     FLA(5)        @WK2                                          CSW09
     C                   MOVEA     @WK2          FLB(6)                                        CSW09
     C                   MOVEA     '/'           FLB(8)                                        CSW09
     C                   MOVEA     FLA(7)        @WK2                                          CSW09
     C                   MOVEA     @WK2          FLB(9)                                        CSW09
     C                   MOVEA     FLB(1)        WKDAT                                         CSW09
     C                   MOVE      WKYY          CHYY                                          CSW09
     C                   ENDIF                                                                 CSW09
      *
      *  Present date in relevant format - DDMMYY or MMDDYY
      *
     C     WUDFF         IFEQ      'M'
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEL     WRKMM         @CHG5
     C                   MOVE      WRKDD         @CHG5
     C                   ELSE                                                                  CSW09
     C                   MOVEL     WKMM          @CH5                                          CSW09
     C                   MOVE      WKDD          @CH5                                          CSW09
     C                   ENDIF                                                                 CSW09
     C                   ELSE
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVE      WRKMM         @CHG5
     C                   MOVEL     WRKDD         @CHG5
     C                   ELSE                                                                  CSW09
     C                   MOVE      WKMM          @CH5                                          CSW09
     C                   MOVEL     WKDD          @CH5                                          CSW09
     C                   ENDIF                                                                 CSW09
     C                   END
      *
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEA     CHGDAT        FLB(1)
     C                   ELSE                                                                  CSW09
     C                   MOVEA     CHDAT         FLB(1)                                        CSW09
     C                   ENDIF                                                                 CSW09
      *
     C                   END                                                              E1
      *                                                                   CRT002
      **  Format the second date (Todays Date) for message tag CDATE.     CRT002
      *                                                                   CRT002
     C     EFMTAG        IFEQ      'CDATE'                                                     CRT00
     C     EFTAGF        ANDEQ     'D'                                                         CRT00
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEA     FLA(7)        @WK2              2                           CRT00
     C                   MOVEA     @WK2          FLB(10)                                       CRT00
     C                   MOVE      '/'           FLB(12)                                       CRT00
     C                   MOVEA     FLA(9)        @WK2                                          CRT00
     C                   MOVEA     @WK2          FLB(13)                                       CRT00
     C                   MOVE      '/'           FLB(15)                                       CRT00
     C                   MOVEA     FLA(11)       @WK2                                          CRT00
     C                   MOVEA     @WK2          FLB(16)                                       CRT00
      *                                                                   CRT002
     C                   MOVEA     FLB(10)       WRKDAT                                        CRT00
     C                   MOVE      WRKYY         CHGYY                                         CRT00
     C                   ELSE                                                                  CSW09
     C                   MOVEA     FLA(7)        @WK2                                          CSW09
     C                   MOVEA     @WK2          FLB(10)                                       CSW09
     C                   MOVEA     '/'           FLB(14)                                       CSW09
     C                   MOVEA     FLA(11)       @WK2                                          CSW09
     C                   MOVEA     @WK2          FLB(15)                                       CSW09
     C                   MOVEA     '/'           FLB(17)                                       CSW09
     C                   MOVEA     FLA(13)       @WK2                                          CSW09
     C                   MOVEA     @WK2          FLB(18)                                       CSW09
     C                   MOVEA     FLB(10)       WKDAT                                         CSW09
     C                   MOVE      WKYY          CHYY                                          CSW09
     C                   ENDIF                                                                 CSW09
      *                                                                   CRT002
      **  Present date in relevant format - DDMMYY or MMDDYY.             CRT002
      *                                                                   CRT002
     C     WUDFF         IFEQ      'M'                                                         CRT00
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEL     WRKMM         @CHG5                                         CRT00
     C                   MOVE      WRKDD         @CHG5                                         CRT00
     C                   ELSE                                                                  CSW09
     C                   MOVEL     WKMM          @CH5                                          CSW09
     C                   MOVE      WKDD          @CH5                                          CSW09
     C                   ENDIF                                                                 CSW09
     C                   ELSE                                                                  CRT00
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVE      WRKMM         @CHG5                                         CRT00
     C                   MOVEL     WRKDD         @CHG5                                         CRT00
     C                   ELSE                                                                  CSW09
     C                   MOVEL     WKMM          @CH5                                          CSW09
     C                   MOVE      WKDD          @CH5                                          CSW09
     C                   ENDIF                                                                 CSW09
     C                   END                                                                   CRT00
      *                                                                   CRT002
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEA     CHGDAT        FLB(10)                                       CRT00
     C                   ELSE                                                                  CSW09
     C                   MOVEA     CHDAT         FLB(10)                                       CSW09
     C                   ENDIF                                                                 CSW09
      *                                                                   CRT002
     C                   END                                                                   CRT00
      *
      *  Move Currency/Amount into formatted array.
      *
      *  Values are extracted from the array dependant on the
      *  combination of data provided.
      *
      *  Date/Currency/Amount
      *
     C     EFTAGF        IFEQ      'DCA'                                                   1
     C     *IN47         IFEQ      '1'                                                         CSW09
     C                   MOVEA     FLA(7)        @WL3              3
     C                   MOVEA     @WL3          FLB(10)
     C                   MOVEA     FLA(10)       @WK15            15
     C                   MOVEA     @WK15         FLB(14)
     C                   ELSE                                                                  CSW09
     C                   MOVEA     FLA(9)        @WL3                                          CSW09
     C                   MOVEA     @WL3          FLB(12)                                       CSW09
     C                   MOVEA     FLA(12)       @WK15                                         CSW09
     C                   MOVEA     @WK15         FLB(16)                                       CSW09
     C                   ENDIF                                                                 CSW09
     C                   END                                                              E1
      *
      *  Currency/Amount
      *
     C     EFTAGF        IFEQ      'CA'                                                    1
     C                   MOVEA     FLA(1)        @WL3
     C                   MOVEA     @WL3          FLB(1)
     C                   MOVEA     FLA(4)        @WK15
     C                   MOVEA     @WK15         FLB(5)
     C                   END                                                              E1
      *
      *  Amount only
      *
     C     EFTAGF        IFEQ      'A'                                                     1
     C                   MOVEA     FLA(1)        FLB(1)
     C                   END                                                              E1
      *
      *  Move formatted field to output data structure
      *
     C                   MOVEA     FLB           MFLD
     C                   MOVEA     FLB           MFLDRP
      *
      *  Unwind subroutine stack name
      *
     C     EXFORM        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRMOVR   : Move right report text                            *
      *                                                               *
      *  CALLED BY:  SRTEXT write message text                        *
      *                                                               *
      *  CALLS    :                                                   *
      *                                                               *
      *****************************************************************
      *
     CSR   SRMOVR        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRMOVR'      @STK(Q)
      *
      *  If blank return
      *
     C     EFRPFD        IFEQ      *BLANKS
     C                   GOTO      EXMOVR
     C                   END
      *
      *  Move Report tag description to array
      *
     C                   MOVEA     *BLANKS       #S
     C                   MOVEA     *BLANKS       #R
     C                   MOVEA     EFRPFD        #R
     C                   Z-ADD     60            S                 5 0
     C                   Z-ADD     60            R                 5 0
     C                   MOVEL     'N'           CHARFD            1            Char found
      *
      *  Scan array from top to bottom
      *
     C     R             DOUEQ     0
      *
      *  If array element blank and not data found - iterate
      *
     C     #R(R)         IFEQ      *BLANKS
     C     CHARFD        ANDEQ     'N'
     C                   SUB       1             R
     C                   ITER
     C                   END
      *
      *  Move array element to new position
      *
     C                   MOVEA     #R(R)         #S(S)
     C                   SUB       1             S
     C                   SUB       1             R
     C                   MOVEL     'Y'           CHARFD            1            Char found
      *
     C                   ENDDO
      *
      *  Move back contents
      *
     C                   MOVEA     #S            EFRPFD
      *
      *  Unwind subroutine stack name
      *
     C     EXMOVR        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *   SRSWAD  : Format Name/Town from SWIFT address and get other *
      *             Network adresses for this SWIFT address           *
      *                                                               *
      *  CALLED BY:  SRTEXT write message text                        *
      *                                                               *
      *  CALLS    :                                                   *
      *                                                               *
      *****************************************************************
      *
     CSR   SRSWAD        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRSWAD'      @STK(Q)
      *
      *  Call Access object to validate identifier
      *
     C                   MOVEL     I#MFLD        W9BICC
     C     3             SUBST     I#MFLD:9      W9BICB
      *
     C                   CALL      'ME1400'
     C                   PARM      *BLANKS       W9RTN             7
     C                   PARM                    W9BICC            8
     C                   PARM                    W9BICB            3
     C                   PARM                    SDCUST
     C                   PARM                    SDCNST
     C                   PARM                    MEBICD
     C                   PARM      *BLANKS       W9CUST            1
     C                   PARM      *BLANKS       W9CNST            1
     C                   PARM      *BLANKS       W9BICD            1
      *
     C                   SELECT
      *
      *  Record not found - S.W.I.F.T does not exist
      *
     C     W9RTN         WHENEQ    'Y2U0005'
      * No action
      *
      *  Use data depending on file that the data exists on
      *
     C     W9BICD        WHENEQ    'Y'
      *
      * Format First Line for screen
      *
     C                   MOVEL     *BLANKS       BICLAY
     C                   MOVEL     BDINS1        #SCR1
      *
      *  Check fields not concatenated
      *
     C     1             SUBST     BDINS2:1      ##001             1
     C     ##001         IFNE      *BLANKS
     C                   MOVEL     BDINS2        #SCR2
     C                   ELSE
     C     15            SUBST     BDINS2:2      #SCR2
     C                   END
     C                   MOVEL     BICLAY        O#MDT2
      *
      * Format Second Line for screen
      *
     C                   MOVEL     *BLANKS       BICLAY
     C                   MOVEL     BDCITY        #SCR1
     C                   MOVEL     BICLAY        O#MDT3
      *
      * Format Third Line for screen
      *
     C                   MOVEL     *BLANKS       BICLAY
     C                   MOVEL     BDBRC1        #SCR1
     C                   MOVEL     BICLAY        O#MDT4
      *
      * Format First Line for report
      *
     C                   MOVEL     *BLANKS       BICLAY
     C                   MOVEL     BDINS1        #RPT1
      *
      *  Check fields not concatenated
      *
     C     1             SUBST     BDINS2:1      ##001             1
     C     ##001         IFNE      *BLANKS
     C                   MOVEL     BDINS2        #RPT2
     C                   ELSE
     C     16            SUBST     BDINS2:2      #RPT2
     C                   END
     C                   MOVEL     BICLAY        O#RDT2
      *
      * Format Second Line for report
      *
     C                   MOVEL     *BLANKS       BICLAY
     C                   MOVEL     BDCITY        #RPT1
     C                   MOVEL     BICLAY        O#RDT3
      *
      * Format Third Line for report
      *
     C                   MOVEL     *BLANKS       BICLAY
     C                   MOVEL     BDBRC1        #RPT1
     C                   MOVEL     BICLAY        O#RDT4
      *
     C     W9CUST        WHENEQ    'Y'
      *
      * Format Screen lines
      *
     C                   MOVEL     *BLANKS       BICLAY
     C                   MOVEL     BBCRNM        #SCR1
     C                   MOVEL     BICLAY        O#MDT2
     C                   MOVEL     *BLANKS       BICLAY
     C                   MOVEL     BBCRTN        #SCR1
     C                   MOVEL     BICLAY        O#MDT3
      *
      * Format Report lines
      *
     C                   MOVEL     *BLANKS       BICLAY
     C                   MOVEL     BBCRNM        #RPT1
     C                   MOVEL     BICLAY        O#RDT2
     C                   MOVEL     *BLANKS       BICLAY
     C                   MOVEL     BBCRTN        #RPT1
     C                   MOVEL     BICLAY        O#RDT3
      *
     C     W9CNST        WHENEQ    'Y'
      *
      * Format Screen lines
      *
     C                   MOVEL     *BLANKS       BICLAY
     C                   MOVEL     AWCPNM        #SCR1
     C                   MOVEL     BICLAY        O#MDT2
     C                   MOVEL     *BLANKS       BICLAY
     C                   MOVEL     AWCNTN        #SCR1
     C                   MOVEL     BICLAY        O#MDT3
      *
      * Format Report lines
      *
     C                   MOVEL     *BLANKS       BICLAY
     C                   MOVEL     AWCPNM        #RPT1
     C                   MOVEL     BICLAY        O#RDT2
     C                   MOVEL     *BLANKS       BICLAY
     C                   MOVEL     AWCNTN        #RPT1
     C                   MOVEL     BICLAY        O#RDT3
      *
     C                   ENDSL
      *
      **  Define standard fields
      *
      *
      *  Unwind subroutine stack name
      *
     C     EXSWAD        TAG
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
      *  CALLS    :                                                   *
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
      *
      *  Define fields
      *
      *
      * Define key list for SDMTAGL0
      *
     C     MGTGK1        KLIST
     C                   KFLD                    MTAGK             5
     C                   KFLD                    MTPYK             3
      *
      * Open Files
      *
     C**********         OPEN      SDMTAGL0                                                 MD056560
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
      *
      * Retreive No description text
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0016'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##NODS           20
      *
      * Retreive Text for sub-file
      *
     C                   CALL      'MEC1150'                            9090
     C                   PARM      'MIN0017'     #MSGID
     C                   PARM      'MEMSG'       #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        ##STXT           76
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
      *
     CSR                 ENDSR
     C/EJECT
      *
      *  File and Program Error Processing
      *
     C*COPY*MECPYSRC,SRERRC                                                                 MD056560
     C/COPY MECPYSRC,SRERRCLE                                                               MD056560
     C/EJECT
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA L65
:44A:                                                                     094636
:44B:                                                                     094636
:44D:                                                                     094636
:45A:                                                                     094636
:45B:                                                                     094636
:46A:                                                                     094636
:46B:                                                                     094636
:47A:                                                                     094636
:47B:                                                                     094636
:78:                                                                      094636
