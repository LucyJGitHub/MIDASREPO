     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO Bank ICD update access object')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  AOBANKU0  - Bank ICD Update                                  *
      *                                                               *
      *  Function:  This program will access and update               *
      *             Bank ICD file                                     *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSC024  *CREATE    Date 07Feb05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC024 - Open Month End                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    90         File Error                                      *
      *    93         Empty                                           *
      *    94         End of File                                     *
      *    96         Action Error                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrUPD    -  Update Records                                   *
      *  SrReturn -  Return Error Code and Set Parameters             *
      *  SrInit   -  Intialisation Proccessing                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDBANKL0  UF   E           K DISK
      ** Bank ICD file
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D P_FMT         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter Lists
     D P_RTCD          S              7
     D P_OPTN          S              7
 
      ** Work Variables in calling ZASNMG
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
 
      ** Do initialisation proccessing.
 
     C                   EXSR      SrInit
 
     C                   SELECT
     C                   WHEN      P_OPTN = '*UPDATE'
     C                   EXSR      SrUPD
     C                   OTHER
     C                   EVAL      *IN96 = *ON
     C                   EXSR      SrReturn
     C                   ENDSL
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUPD    -  Update ICD record                                *
      *                                                               *
      *  Called by: Main Program                                      *
      *                                                               *
      *  Calls    : none                                              *
      *                                                               *
      *****************************************************************
 
     C     SrUPD         BEGSR
 
     C                   READ      SDBANKL0                             9094
     C                   IF        *IN94 = *ON
     C                             OR *IN90 = *ON
     C                   EVAL      *IN93 = *ON
     C                   EXSR      SrReturn
     C                   ENDIF
 
     C                   MOVEL     P_FMT         SDBANK
     C                   UPDATE    @BJREEE
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrReturn -  Return Error Code and Set Parameters             *
      *                                                               *
      *  Called by: Main Program                                      *
      *                                                               *
      *  Calls    : ZASNMG, DBERRCTL                                  *
      *                                                               *
      *****************************************************************
 
     C     SrReturn      BEGSR
 
      ** Return Error Code
 
     C                   EVAL      P_RTCD = *BLANKS
 
     C                   SELECT
     C                   WHEN      *IN90 = *ON
     C                   EVAL      P_RTCD = '*ERROR '
 
     C                   WHEN      *IN93 = *ON
     C                   EVAL      P_RTCD = '*EMPTY '
 
     C                   WHEN      *IN96 = *ON
     C                   EVAL      P_RTCD = '*ACTION'
 
     C                   ENDSL
 
      ** Caller requests message sent to program queue
 
     C                   IF        (P_RTCD <> *Blanks)
 
     C                   SELECT
     C                   WHEN      *IN90 = *ON
     C                   EVAL      P_MGID = 'ACO1001'
 
     C                   WHEN      *IN93 = *ON
     C                   EVAL      P_MGID = 'ACO1004'
 
     C                   WHEN      *IN96 = *ON
     C                   EVAL      P_MGID = 'ACO1007'
 
     C                   ENDSL
 
     C                   CALL      'ZASNMG'
     C                   PARM      *BLANKS       W_RTCD
     C                   PARM      'AOBANKU0'    P_PGNM
     C                   PARM      '*PRV'        P_DEST
     C                   PARM                    P_MGID
     C                   PARM      *BLANKS       P_MGSF
     C                   PARM      *BLANKS       P_MGKY
     C                   PARM                    P_MGDA
     C                   PARM      '*DIAG'       P_MGTP
 
     C                   ENDIF
 
      ** Caller Requests DB Error Handling
 
     C                   IF        (P_RTCD <> *BLANK)
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit   -  Intialisation Proccessing                        *
      *                                                               *
      *  Called by: Main Program                                      *
      *                                                               *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
 
     C     SrInit        BEGSR
 
      ** Receive entry parameter
 
     C     *ENTRY        PLIST
     C                   PARM                    P_RTCD
     C                   PARM                    P_OPTN
     C                   PARM      SDBANK        P_FMT
 
      ** Initialise error indicators
 
     C                   EVAL      *IN90 = *OFF
     C                   EVAL      *IN93 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN96 = *OFF
     C                   EVAL      P_RTCD = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
