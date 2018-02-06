     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Settlement Allocations Read Access Object')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  AOSTALR0  - Read Access to Settlement Allocation File        *
      *                                                               *
      *  Function:  This program will access the Settlement           *
      *             Allocation Transaction files LF/LESTALL0          *
      *             LF/LESTALL2.                                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG8924            Date 26Sep05               *
      *                 CLE038             Date 13May04               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE034  *CREATE    Date 05May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  BUG8924- Incorrect postings for Settlement Allocation when   *
      *           amount is used. Use very long Dummy DS.             *
      *  CLE038 - Lending Enhancement for Nordea: Allocation by Amount*
      *           (Recompiled over changes to LESTALPD).              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Open file LESTALL0                              *
      *    02         Open file LESTALL2                              *
      *    90         File Error                                      *
      *    91         Open Error                                      *
      *    92         Close Error                                     *
      *    93         Empty File                                      *
      *    94         End of File                                     *
      *    95         No Record found                                 *
      *    96         Option Error                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  SRReturn      -  Return Error Code and Set Parameters        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FLESTALL0  IF   E           K DISK    USROPN
     F                                     RENAME(LESTALD0:@STAL0)
      ** Settlement Allocation by Transaction File
      *
     FLESTALL2  IF   E           K DISK    USROPN
     F                                     RENAME(LESTALD0:@STAL2)
      ** Settlement Allocation by Transaction and Sequence
      *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
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
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D D@FMT         E DS                  EXTNAME(LESTALPD)
      ** External data structure to hold the outgoing record format
     D*P_RFMT***     E DS                  EXTNAME(DSSDY)                                    BUG8924
     D P_RFMT        E DS                  EXTNAME(DSLDY)                                    BUG8924
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter Lists
 
     D P_RTCD          S              7
     D P_OPTN          S              7
     D P_TYPE          S              4
     D P_LNRF          S              6
     D P_LAVD          S              5
     D P_LNAS          S              3
     D P_CUSF          S              6
     D P_FACF          S              5
     D P_FEES          S              2
     D P_TMSP          S             26Z
     D P_SEQ           S              5
     D W_RTCD          S              7
 
      ** KLIST fields
 
     D KTYPE           S              4
     D KTMST           S             26Z
     D*KLNRF****       S              6S 0                                                    CLE148
     D KLNRF           S              6A                                                      CLE148
     D KVDAT           S              5S 0
     D KLASQ           S              3S 0
     D*KCNUM****       S              6S 0                                                    CSD027
     D KCNUM           S              6                                                       CSD027
     D KFACL           S              5S 0
     D KFESQ           S              2S 0
     D KSEQ            S              5S 0
 
      ** Work Variables in calling ZASNMG
 
     D P_PGNM          S             10
     D P_DEST          S              5
     D P_MGID          S              7
     D P_MGSF          S             10
     D P_MGKY          S              4
     D P_MGDA          S             50
     D P_MGTP          S              7
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Receive entry parameter
 
     C     *ENTRY        PLIST
     C     W_RTCD        PARM                    P_RTCD
     C                   PARM                    P_OPTN
     C                   PARM                    P_TYPE
     C                   PARM                    P_LNRF
     C                   PARM                    P_LAVD
     C                   PARM                    P_LNAS
     C                   PARM                    P_CUSF
     C                   PARM                    P_FACF
     C                   PARM                    P_FEES
     C                   PARM                    P_TMSP
     C                   PARM                    P_SEQ
     C                   PARM                    P_RFMT
 
      ** Initialise error indicators
 
     C                   EVAL      *IN90 = *OFF
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN96 = *OFF
 
     C     KKEY0         KLIST
     C                   KFLD                    KTYPE
     C                   KFLD                    KTMST
     C                   KFLD                    KLNRF
     C                   KFLD                    KVDAT
     C                   KFLD                    KLASQ
     C                   KFLD                    KCNUM
     C                   KFLD                    KFACL
     C                   KFLD                    KFESQ
 
     C     KKEY2         KLIST
     C                   KFLD                    KTYPE
     C                   KFLD                    KTMST
     C                   KFLD                    KLNRF
     C                   KFLD                    KVDAT
     C                   KFLD                    KLASQ
     C                   KFLD                    KCNUM
     C                   KFLD                    KFACL
     C                   KFLD                    KFESQ
     C                   KFLD                    KSEQ
 
      ** First call - open file
 
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN01 = *ON
     C                   OPEN      LESTALL0                             91
     C                   IF        *IN91
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN02 = *OFF
     C                   EVAL      *IN02 = *ON
     C                   OPEN      LESTALL2                             91
     C                   IF        *IN91
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
      ** Last call - close file and terminate program
 
     C                   IF        P_OPTN = '*FREE  '
     C                   CLOSE     LESTALL0                             92
     C                   IF        *IN92 = *OFF
     C                   CLOSE     LESTALL2                             92
     C                   ENDIF
     C                   ENDIF
 
      ** If Option is *FIRST
 
     C                   IF        P_OPTN = '*FIRST '
 
      ** Move values from PLIST to the key fields
 
     C                   EVAL      KTYPE = P_TYPE
     C                   MOVE      P_LNRF        KLNRF
     C                   MOVE      P_LAVD        KVDAT
     C                   MOVE      P_LNAS        KLASQ
     C                   MOVE      P_CUSF        KCNUM
     C                   MOVE      P_FACF        KFACL
     C                   MOVE      P_FEES        KFESQ
     C                   MOVE      P_TMSP        KTMST
     C                   MOVE      P_SEQ         KSEQ
 
     C     KKEY0         SETLL     LESTALL0                           9390
     C                   IF        *IN93 = *OFF  AND  *IN90 = *OFF
     C                   EVAL      P_OPTN = '*NEXT  '
     C                   ENDIF
     C                   ENDIF
 
      ** If option is *NEXT
 
     C                   IF        P_OPTN = '*NEXT  '
     C     KKEY0         READE     LESTALL0                             9094
     C                   ENDIF
 
      ** If Option is *KEY, access LESTALL2
 
     C                   IF        P_OPTN = '*KEY   '
     C     KKEY2         CHAIN     LESTALL2                           9590
     C                   ENDIF
 
      ** If parameter error
 
     C                   IF        (P_OPTN <> '*FIRST ') AND
     C                             (P_OPTN <> '*NEXT  ') AND
     C                             (P_OPTN <> '*KEY   ') AND
     C                             (P_OPTN <> '*FREE  ')
     C                   EVAL      *IN96 = *ON
     C                   ENDIF
 
     C                   MOVEL     D@FMT         P_RFMT
     C                   EXSR      SRReturn
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReturn - Return Error Code and Set Parameters               *
      *                                                               *
      *  Called by: Main Program                                      *
      *                                                               *
      *  Calls    : ZASNMG, DBERRCTL                                  *
      *                                                               *
      *****************************************************************
 
     C     SRReturn      BEGSR
 
      ** Return Error Code
 
     C                   EVAL      P_RTCD = *BLANKS
 
     C                   SELECT
     C     *IN90         WHENEQ    *ON
     C                   EVAL      P_RTCD = '*ERROR '
     C                   EVAL      *INLR = *ON
     C     *IN91         WHENEQ    *ON
     C                   EVAL      P_RTCD = '*OPEN  '
     C                   EVAL      *INLR = *ON
     C     *IN92         WHENEQ    *ON
     C                   EVAL      P_RTCD = '*CLOSE '
     C                   EVAL      *INLR = *ON
     C     *IN93         WHENEQ    *ON
     C                   EVAL      P_RTCD = '*EMPTY '
     C     *IN94         WHENEQ    *ON
     C                   EVAL      P_RTCD = '*EOF   '
     C     *IN95         WHENEQ    *ON
     C                   EVAL      P_RTCD = '*NRF   '
     C     *IN96         WHENEQ    *ON
     C                   EVAL      P_RTCD = '*OPTION'
     C                   ENDSL
 
      ** Caller requests message sent to program queue
 
     C                   IF        (W_RTCD = '*MSG   ') AND
     C                             (P_RTCD <> *Blanks)
 
     C                   SELECT
     C     *IN90         WHENEQ    *ON
     C                   EVAL      P_MGID = 'ACO1001'
     C     *IN91         WHENEQ    *ON
     C                   EVAL      P_MGID = 'ACO1002'
     C     *IN92         WHENEQ    *ON
     C                   EVAL      P_MGID = 'ACO1003'
     C     *IN93         WHENEQ    *ON
     C                   EVAL      P_MGID = 'ACO1004'
     C     *IN94         WHENEQ    *ON
     C                   EVAL      P_MGID = 'ACO1005'
     C     *IN95         WHENEQ    *ON
     C                   EVAL      P_MGID = 'ACO1006'
     C     *IN96         WHENEQ    *ON
     C                   EVAL      P_MGID = 'ACO1007'
     C                   ENDSL
 
     C                   CALL      'ZASNMG'
     C                   PARM      *BLANKS       W_RTCD
     C                   PARM      'AOSTALR0'    P_PGNM
     C                   PARM      '*PRV'        P_DEST
     C                   PARM                    P_MGID
     C                   PARM      *BLANKS       P_MGSF
     C                   PARM      *BLANKS       P_MGKY
     C                   PARM                    P_MGDA
     C                   PARM      '*DIAG'       P_MGTP
 
     C                   ENDIF
 
      ** Caller Requests DB Error Handling
 
     C                   IF        (W_RTCD = '*DBERR ') AND
     C                             (P_RTCD <> *BLANK)
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
