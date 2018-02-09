     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Write Hierarchy Validation Errors')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  RE100410  - Write Hierarchy Validation Errors                *
      *                                                               *
      *  Function:  This module writes details of hierarchy           *
      *             validation errors to the file RECMVEPD.           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008  *CREATE    Data 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FREZSMXL0  IF   E           K DISK    INFSR(*PSSR)
     FREGAMXL0  IF   E           K DISK    INFSR(*PSSR)
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     FRECMVEPD  O    E             DISK
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
 
      * Account ID
     D                 DS
     D***ACCID**                 1     18                                                     CGL029
     D ACCID                   1     24                                                       CGL029
     D BRC                     1      3
     D*CUS******               4      9S 0                                                    CSD027
     D CUS                     4      9A                                                      CSD027
     D CCY                    10     12
     D***ACD****                13     16S 0                                                  CGL029
     D***ASN****                17     18S 0                                                  CGL029
     D ACD                    13     22S 0                                                    CGL029
     D ASN                    23     24S 0                                                    CGL029
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Externally described DS for bank details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** Second DS for access programs
 
 
     IREZSMXD0
     I              ZMCBRC                      BRC
     I              ZMCCUS                      CUS
     I              ZMCCCY                      CCY
     I              ZMCACD                      ACD
     I              ZMCASN                      ASN
     IREGAMXD0
     I              GMCBRC                      BRC
     I              GMCCUS                      CUS
     I              GMCCCY                      CCY
     I              GMCACD                      ACD
     I              GMCASN                      ASN
 
 
 
      * Record the time
 
     C                   TIME                    NUM_TIME          6 0
 
      * Write summary record
 
     C                   EVAL      VEHIER = I_HIER
     C                   EVAL      VEHISN = I_HISN
     C                   EVAL      VEHTYP = I_HTYP
     C                   EVAL      VESEQN = *ZERO
     C                   EVAL      VEMSGA = I_MSGA
     C                   EVAL      VEDATE = BJMRDT
     C                   EVAL      VETIME = NUM_TIME
     C                   WRITE     RECMVED0
 
      * Write message records
 
     C                   Z-ADD     1             Offset            4 0
     C                   Z-ADD     0             MsgStr            4 0
     C                   Z-ADD     0             MsgEnd            4 0
     C                   Z-ADD     0             MsgLen            4 0
 
     C     VEMSGA        DOUEQ     *BLANK
 
     C                   ADD       1             VESEQN
     C                   MOVEL     *BLANK        VEMSGA
 
     C                   EVAL      MsgStr = %scan(':E:' : I_MSGA : Offset)
     C                   IF        MsgStr > 0
     C                   EVAL      MsgStr = MsgStr + 3
     C                   EVAL      Offset = MsgStr
     C                   EVAL      MsgEnd = %scan(':' : I_MSGA : Offset)
     C                   IF        MsgEnd > 0
     C                   EVAL      MsgLen = MsgEnd - MsgStr
     C                   EVAL      VEMSGA = %subst(I_MSGA: MsgStr :MsgLen)
     C                   ENDIF
     C                   ENDIF
 
      * Strip hierarchy error text
 
     C                   IF         %subst(VEMSGA: 1 :12) = 'HIERARCHY = '
     C                   EVAL      VEMSGA = %subst(VEMSGA: 24 :1000)
     C                   ENDIF
 
      * Reformat member error text
 
     C                   IF         %subst(VEMSGA: 1 :9) = 'MEMBER = '
     C                   MOVE      *BLANK        LINKA             9
     C                   EVAL      LINKA  = %subst(VEMSGA: 10 :9)
     C                   TESTN                   LINKA                9898
     C     *IN98         IFEQ      '1'
     C                   MOVE      LINKA         MID               9 0
     C     MID           CHAIN     REZSMXL0                           99
     C   99MID           CHAIN     REGAMXL0                           99
     C     ACCNTK        CHAIN     ACCNTABF                           99
     C     *in99         IFEQ      '0'
     C     ACNO          ANDNE     *ZERO
     C                   MOVE      ACNO          ACNOA            10
     C                   IF         %subst(VEMSGA: 20 :1) = ' '
     C                   EVAL      VEMSGA = 'MEMBER = ' + ACNOA + '. '
     C                                      + %subst(VEMSGA: 21 :1000)
     C                   ELSE
     C                   EVAL      VEMSGA = 'MEMBER = ' + ACNOA + '. '
     C                                      + %subst(VEMSGA: 20 :1000)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C     VEMSGA        IFNE      *BLANK
     C                   WRITE     RECMVED0
     C                   EVAL      Offset = MsgEnd + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * INPUTS
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_HISN           10
     C                   PARM                    I_HTYP            2
     C                   PARM                    I_MSGA         2000
 
      * Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Key lists
 
     C     ACCNTK        KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
