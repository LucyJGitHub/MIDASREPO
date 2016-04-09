     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Watch List Check Configuration Access Obj')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOWLCCR0 - Watch List Check Configuration Access Object      *
      *                                                               *
      *  Function:  This program will access the LF/SDWLCCL0 using    *
      *             the given Function Code.                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Open File                                       *
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
      *  SRReturn      -  Return Error Code and Set Parameters        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDWLCCL0  IF   E           K DISK    USROPN
      ** Midas Functions for Watch List Checking Details by Function Code
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
 
     D D_RFMT        E DS                  EXTNAME(SDWLCCPD)
      ** File Information Data Structure
 
     D P_RFMT        E DS                  EXTNAME(DSFDY)
      ** External Data Structure to Hold the Outgoing Record Format
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D W_RTCD          S              7A
     D P_RTCD          S              7A
     D P_OPTN          S              7A
     D P_FUNC          S              8A
     D P_MGID          S              7A
     D P_PGNM          S             10A
     D P_DEST          S              5A
     D P_MGSF          S             10A
     D P_MGKY          S              4A
     D P_MGDA          S             50A
     D P_MGTP          S              7A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Receive entry parameter
 
     C     *ENTRY        PLIST
     C     W_RTCD        PARM                    P_RTCD
     C                   PARM                    P_OPTN
     C                   PARM                    P_FUNC
     C                   PARM                    P_RFMT
 
      ** Initialise return parameter
 
     C                   IF        P_OPTN = '*SAME  '
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN91 = *ON
     C                   ELSE
     C                   EVAL      *IN91 = *OFF
     C                   ENDIF
     C                   EXSR      SRReturn
     C                   ENDIF
 
      ** Initialise error indicators
 
     C                   EVAL      *IN90 = *OFF
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN96 = *OFF
 
      ** First call - open file
 
     C                   IF        *IN01 = *OFF
     C                   OPEN      SDWLCCL0                             91
     C                   IF        *IN91 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      *IN01 = *ON
     C                   ENDIF
 
      ** Last call - close file and terminate program
 
     C                   IF        P_OPTN = '*FREE  '
     C                   CLOSE     SDWLCCL0                             92
 
      ** If error in closing file
 
     C                   IF        *IN92 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      *INLR = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
 
      ** If Option is *FIRST
 
     C                   IF        P_OPTN = '*FIRST '
     C     *LOVAL        SETLL     SDWLCCL0                           9390
     C                   IF        *IN93 = *ON or *IN90 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      P_OPTN = '*NEXT  '
     C                   ENDIF
 
      ** If option is *NEXT
 
     C                   IF        P_OPTN = '*NEXT  '
     C                   READ      SDWLCCL0                             9094
     C                   IF        *IN94 = *ON or *IN90 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
      ** If Option is *LAST
 
     C                   IF        P_OPTN = '*LAST  '
     C     *HIVAL        SETGT     SDWLCCL0                             90
     C                   IF        *IN90 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      P_OPTN = '*PREV  '
     C                   ENDIF
 
      ** If Option is *PREV
 
     C                   IF        P_OPTN = '*PREV  '
     C                   READP     SDWLCCL0                             9094
     C                   IF        *IN94 = *ON or *IN90 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
      ** If Option is *KEY or Option is *VERIFY
 
     C                   IF        (P_OPTN = '*KEY   ') or
     C                             (P_OPTN = '*VERIFY')
 
      ** Access SDWLCCL0
 
     C     P_FUNC        CHAIN     SDWLCCL0                           9590
     C                   IF        *IN95 = *ON or *IN90 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
 
     C                   ENDIF
 
      ** If parameter error
 
     C                   IF        (P_OPTN <> '*KEY   ') and
     C                             (P_OPTN <> '*NEXT  ') and
     C                             (P_OPTN <> '*PREV  ') and
     C                             (P_OPTN <> '*VERIFY') and
     C                             (P_OPTN <> '*FREE  ')
     C                   EVAL      *IN96 = *ON
     C                   ENDIF
 
     C                   EXSR      SRReturn
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReturn - Return Error Code and Set Parameters              *
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
 
     C                   IF        (W_RTCD = '*MSG   ') and
     C                             (P_RTCD <> *BLANKS)
 
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
     C                   PARM      'AOWLCCR0'    P_PGNM
     C                   PARM      '*PRV'        P_DEST
     C                   PARM                    P_MGID
     C                   PARM      *BLANKS       P_MGSF
     C                   PARM      *BLANKS       P_MGKY
     C                   PARM      *BLANKS       P_MGDA
     C                   PARM      '*DIAG'       P_MGTP
 
     C                   ENDIF
 
      ** Caller requests DB error handling
 
     C                   IF        (W_RTCD = '*DBERR ') and
     C                             (P_RTCD <> *BLANKS)
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   IF        (P_OPTN <> '*VERIFY') and
     C                             (P_OPTN <> '*FREE  ') and
     C                             (P_OPTN <> '*OPTION')
     C                   EVAL      P_RFMT = D_RFMT
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
 
** CPY@
(c) Misys International Banking Systems Ltd. 2002
