     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Hedging ICD Access Object')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  AOHEDGR0 - Hedge ICD Access Object                           *
      *                                                               *
      *  Function:  This program will access the Hedging ICD Details  *
      *             LF/SDHEDGL1                                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. 233545             Date 18May05               *
      *                 232348             Date 21Feb05               *
      *                 CAS009             Date 16May05               *
      *                 228948             Date 27Sep04               *
      *                 229418             Date 02Sep04               *
      *                 229123             Date 19Aug04
      *                 CAS008             Date 11May04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS002  *CREATE    Date 14Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  233545 - Cut-off Date (Recompile)                            *
      *  232348 - Introduce cut-off date for non-linear amortisation  *
      *           (Recompile)                                         *
      *  CAS009 - EIR/AC Accounting (Recompile)                       *
      *  228948 - Add 'Exclude Accrued Interest in Unrealized Profit  *
      *           or Loss' (Recompile).                               *
      *  229418 - Should add number of days for hedge effectiveness   *
      *           tolerance.                                          *
      *  229123 - Parameter Mismatch                                  *
      *  CAS008 - Delayed Hedge Assessment (Recompile)                *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS002 - Hedge Strategy/Linkage                              *
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
      *    96         Option Error                                    *
      *    97         No selection                                    *
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
 
     FSDHEDGL1  IF   E           K DISK    USROPN
      ** Hedging ICD Master File Retrieval Index
 
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
 
      ** File information data structure
     D D_RFMT        E DS                  EXTNAME(SDHEDGPD)
 
      ** External data structure to hold the outgoing record format
     D*P_RFMT***     E DS                  EXTNAME(DSSDY)                                     229123
     D P_RFMT        E DS                  EXTNAME(DSFDY)                                     229123
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D P_RTCD          S              7
     D P_OPTN          S              7
     D P_RCODE         S              7
     D P_MODE          S              1
     D W_RTCD          S              7
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
     C                   PARM      D_RFMT        P_RFMT
 
      ** Initialise error indicators
 
     C                   EVAL      *IN90 = *OFF
     C                   EVAL      *IN91 = *OFF
     C                   EVAL      *IN92 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN96 = *OFF
 
      ** First call - open file - read record - close file
      ** Subsequent calls will return the format
 
     C                   IF        (P_OPTN = '*FIRST ') OR
     C                             (P_OPTN = '*NEXT  ') OR
     C                             (P_OPTN = '*PREV  ') OR
     C                             (P_OPTN = '*LAST  ') OR
     C                             (P_OPTN = '*KEY   ') OR
     C                             (P_OPTN = '*SAME  ') OR
     C                             (P_OPTN = '*VERIFY')
     C                   IF        *IN01 = *OFF
     C                   EVAL      *IN01 = *ON
     C                   OPEN      SDHEDGL1                             91
     C                   IF        *IN91
     C                   EVAL      *INLR = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C     *LOVAL        SETLL     SDHEDGL1                           9390
     C                   IF        *IN93 = *OFF
     C                   READ      SDHEDGL1                               93
     C                   ENDIF
     C                   CLOSE     SDHEDGL1                             92
     C                   IF        *IN93
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   IF        *IN90
     C                   EVAL      *INLR = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   IF        *IN92
     C                   EVAL      *INLR = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ELSE
 
     C                   IF        P_OPTN = '*FREE  '
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ELSE
     C                   EVAL      *IN96 = *ON
     C                   EXSR      SRReturn
     C                   ENDIF
     C                   ENDIF
 
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
     C     *IN96         WHENEQ    *ON
     C                   EVAL      P_MGID = 'ACO1007'
     C                   ENDSL
 
     C                   CALL      'ZASNMG'
     C                   PARM      *BLANKS       W_RTCD
     C                   PARM      'AOHEDGR0'    P_PGNM
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
(c) Finastra International Limited 2001
