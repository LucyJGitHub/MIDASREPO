     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GP Audit Change Header - Write')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPAUCHWRT - Audit Change Header - Write                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD026981           Date 16May14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BG1928             Date 15Apr03               *
      *                 CGP004  *CREATE    Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD026981 - Remove blanks from REF ID for EERT                *
      *  BG1928 - Audit deliverable data missing                      *
      *  CGP004 - Audit Reporting                                     *
      *                                                               *
      *****************************************************************
 
     FGPAUCHPD  O    E             DISK    INFSR(*PSSR)
     FGPAUUIL0  IF   E           K DISK    INFSR(*PSSR)
 
     D #REFI           DS                                                                 MD026981
     D  #FCCY                  1      3                                                   MD026981
     D  #CUST                  4      9                                                   MD026981
     D  #NOSC                 10     11                                                   MD026981
     D  #DAT                  12     18                                                   MD026981
     D  #TCCY                 19     21                                                   MD026981
                                                                                          MD026981
      * Convert In Date to YYMMDD format
 
     C                   EXSR      CONVERT_INDAT
 
      * Zone
     C                   MOVEL     I#ZONE        AHZONE
      * ID
     C                   Z-ADD     I#SEQN        AHCID
     C                   MOVEL     Conv_InDATE   AHCID
      * Run Day Number
      * Input
      * Branch
      * Reference ID
      * Action
      * User
     C                   MOVEL     I#RDNB        AHRDNB
     C                   MOVEL     I#INPT        AHINPT
     C                   MOVEL     I#BRCA        AHBRCA
      *                                                                                     MD026981
     C     I#INPT        Ifeq      'EERT'                                                   MD026981
     C                   move      *Blanks       #REFI                                      MD026981
     C                   movel     I#REFI        #REFI                                      MD026981
     C     #CUST         Ifeq      *Blanks                                                  MD026981
     C                   eval      AHREFI  = #FCCY + #NOSC + #DAT                           MD026981
     C                                       + #TCCY                                        MD026981
     C                   else                                                               MD026981
     C                   eval      AHREFI  = #FCCY + #CUST + #DAT                           MD026981
     C                                       + #TCCY                                        MD026981
     C                   Endif                                                              MD026981
     C                   else                                                               MD026981
     C                   MOVEL     I#REFI        AHREFI
     C                   Endif                                                              MD026981
      *                                                                                     MD026981
     C                   MOVEL     I#ACTN        AHACTN
     C                   MOVEL     I#USER        AHUSER
     C                   MOVEL     *BLANK        TransType         4
     C     AHUSER        IFEQ      'QUSER'
     C                   EXSR      DET_USER
     C                   ENDIF
      * File
      * Record ID
      * Entry Type
      * Job Number
      * Program
      * Date
      * Time
      * Commit ID
      * Rollback
     C                   MOVEL     I#FILE        AHFILE
     C                   MOVEL     I#RCID        AHRCID
     C                   MOVEL     I#ENTT        AHENTT
     C                   Z-ADD     I#JNBR        AHJNBR
     C                   MOVEL     I#PGM         AHPGM
     C                   MOVEL     Conv_InDATE   AHDATE
     C                   Z-ADD     I#TIME        AHTIME
     C     I#CCID        IFNE      0
     C                   Z-ADD     I#CCID        AHCCID
     C                   ELSE
     C                   Z-ADD     I#SEQN        AHCCID
     C                   ENDIF
     C                   MOVEL     I#RLBK        AHRLBK
     C                   MOVEL     TransType     AHTTYP
 
     C                   WRITE     GPAUCHD0
 
      * Return
 
     C                   RETURN
      *
     C/SPACE 5
      ********************************************************************
      * Convert In Date to YYMMDD format
      * (In Date is in DDMMYY format)
      ********************************************************************
     C     CONVERT_INDAT BEGSR
 
     C                   MOVEL     I#DATE        Work40            4 0
     C                   MOVEL     Work40        Day               2 0
     C                   MOVE      Work40        Month             2 0
     C                   MOVEL     Month         Work40
     C                   MOVE      Day           Work40
     C                   MOVE      Work40        Conv_InDATE       6 0
 
     C                   MOVE      I#DATE        Year              2 0
     C                   MOVEL     Year          Conv_InDATE
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * Determine user
      ********************************************************************
     C     DET_USER      BEGSR
 
     C*****GPAUUIK_F*****SETLL     GPAUUID0                                                   BG1928
     C     GPAUUIK_F     SETGT     GPAUUID0                                                   BG1928
     C     GPAUUIK_P     READPE    GPAUUID0                               99    *
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     AIUSER        AHUSER
     C                   MOVEL     AITTYP        TransType
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
      * INPUT
      * Zone
      * Run Day Number
     C                   PARM                    I#ZONE           10
     C                   PARM                    I#RDNB            5 0
      * Input
      * Branch
      * Reference ID
      * Action
     C                   PARM                    I#INPT            4
     C                   PARM                    I#BRCA            3
     C                   PARM                    I#REFI           40
     C                   PARM                    I#ACTN           10
      * Journal Entry Type
      * Journal User
      * Journal Sequence Number
      * Journal File
      * Journal Job Number
      * Journal Program
      * Journal Date
      * Journal Time
      * Journal Commit ID
     C                   PARM                    I#ENTT            2
     C                   PARM                    I#USER           10
     C                   PARM                    I#SEQN           10 0
     C                   PARM                    I#FILE           10
     C                   PARM                    I#JNBR            6 0
     C                   PARM                    I#PGM            10
     C                   PARM                    I#DATE            6
     C                   PARM                    I#TIME            6 0
     C                   PARM                    I#CCID           10 0
      * Rollback
     C                   PARM                    I#RLBK            1
      * Record ID
     C                   PARM                    I#RCID           15
 
      * Key list
 
     C     GPAUUIK_F     KLIST
     C                   KFLD                    I#ZONE
     C                   KFLD                    I#JNBR
     C                   KFLD                    Conv_InDATE
     C                   KFLD                    I#TIME
     C     GPAUUIK_P     KLIST
     C                   KFLD                    I#ZONE
     C                   KFLD                    I#JNBR
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GPCPYSRCG,GPPSSR
      *****************************************************************
