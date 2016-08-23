     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Global Customer Details access object')
      *****************************************************************
      *                                                               *
      *  Midas - Access Objects                                       *
      *                                                               *
      *  AOGCSTR0 - Read Access to Global Customer Details File       *
      *                                                               *
      *  Function:  This program will access the LF/GPCUSTL0 using    *
      *             the given global customer id.                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CGP001   *CREATE   Date 23May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGP001 - Global Processing                                   *
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
      *    97         No Select Error                                 *
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
 
     FGPCUSTL0  IF   E           K DISK    USROPN
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
 
      ** File Information Data Structure
     D GPCUSTSD      E DS                  EXTNAME(GPCUSTPD)
 
      ** External Data Structure to Hold the Outgoing Record Format
     D P_RFMT        E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D W_RTCD          S              7A
     D P_RTCD          S              7A
     D P_OPTN          S              7A
     D P_GCUS          S             10A
     D P_GCUS1         S              1A
     D P_MGID          S              7A
     D P_PGNM          S             10A
     D P_DEST          S              5A
     D P_MGSF          S             10A
     D P_MGKY          S              4A
     D P_MGDA          S             50A
     D P_MGTP          S              7A
     D PGlbCustID      S             10A
     D PRetCde         S              7A
 
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
     C                   PARM                    P_GCUS
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
     C                   EVAL      *IN97 = *OFF
 
      ** First call - open file
 
     C                   IF        *IN01 = *OFF
     C                   OPEN      GPCUSTL0                             91
     C                   IF        *IN91 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      *IN01 = *ON
     C                   ENDIF
 
      ** Last call - close file and terminate program
 
     C                   IF        P_OPTN = '*FREE  '
     C                   CLOSE     GPCUSTL0                             92
 
      ** If error in closing file
 
     C                   IF        *IN92 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      *INLR = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
 
      ** If Option is *FIRST
 
     C                   IF        P_OPTN = '*FIRST '
     C     *LOVAL        SETLL     GPCUSTL0                           9390
     C                   IF        *IN93 = *ON or *IN90 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      P_OPTN = '*NEXT  '
     C                   ENDIF
 
      ** If option is *NEXT
 
     C                   IF        P_OPTN = '*NEXT  '
     C                   READ      GPCUSTL0                             9094
     C                   IF        *IN94 = *ON or *IN90 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
      ** If Option is *LAST
 
     C                   IF        P_OPTN = '*LAST  '
     C     *HIVAL        SETGT     GPCUSTL0                             90
     C                   IF        *IN90 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      P_OPTN = '*PREV  '
     C                   ENDIF
 
      ** If Option is *PREV
 
     C                   IF        P_OPTN = '*PREV  '
     C                   READP     GPCUSTL0                             9094
     C                   IF        *IN94 = *ON or *IN90 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
      ** If Option is *KEY or Option is *VERIFY
 
     C                   IF        (P_OPTN = '*KEY   ') or
     C                             (P_OPTN = '*VERIFY')
 
      ** Check for selection request
 
     C                   EVAL      P_GCUS1 = P_GCUS
     C                   IF        P_GCUS1 = '?'
 
     C                   CALL      'SD000010S'
     C                   PARM      *BLANKS       PRetCde
     C                   PARM                    PGlbCustID
 
     C                   IF        PretCde = *BLANKS
     C                   EVAL      P_GCUS = PGlbCustID
     C                   ELSE
     C                   EVAL      *IN97 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
      ** Access GPCUSTL0
 
     C     P_GCUS        CHAIN     GPCUSTL0                           9590
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
     C     *IN97         WHENEQ    *ON
     C                   EVAL      P_RTCD = '*NOSEL '
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
     C     *IN97         WHENEQ    *ON
     C                   EVAL      P_MGID = 'ACO1008'
     C                   ENDSL
 
     C                   CALL      'ZASNMG'
     C                   PARM      *BLANKS       W_RTCD
     C                   PARM      'AOGCSTR0'    P_PGNM
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
     C                   EVAL      P_RFMT = GPCUSTSD
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
 
** CPY@
(c) Misys International Banking Systems Ltd. 2003
