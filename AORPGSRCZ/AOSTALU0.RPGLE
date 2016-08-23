     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*XBI *  OVRDBF FILE(LESTAL5X) TOFILE(LESTALL5) SHARE(*NO)            *                       221427
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Settlement Allocation Update Access Objct')   *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  AOSTALU0  - Update Access to Settlement Allocation File      *
      *                                                               *
      *  Function:  This program will access the Settlement           *
      *             Allocation Transaction files LF/LESTALL0,         *
      *             LF/LESTALL2, and LESTALL5.                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      *  Prev Amend No. CCB020             Date 06Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CLE038             Date 13May04               *
      *                 CSD027             Date 09Dec05               *
      *                 221427             Date 22Sep03               *
      *                 CLE034  *CREATE    Date 05May03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CCB020 - COB Restructure - Secondary COB Infrastructure      *
      *  CLE038 - Lending Enhancement for Nordea: Allocation by Amount*
      *           (Recompiled over changes to LESTALPD).              *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  221427 - When this program runs in close of business         *
      *           commitment control is not valid.                    *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    90         File Error                                      *
      *    94         End of File                                     *
      *    95         No Record Found                                 *
      *    96         Action Error                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrDEL    -  Delete Records.                                  *
      *  SrUPD    -  Update Records                                   *
      *  SrMAT    -  Mature Records                                   *
      *  SrReturn -  Return Error Code and Set Parameters             *
      *  SrInit   -  Intialisation Proccessing                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FLESTALL0  UF   E           K DISK    RENAME(LESTALD0:@STAL0)
     F                                     COMMIT
     F                                     USROPN                                             221427
      ** Settlement Allocation by Transaction File
 
     FLESTALL2  UF   E           K DISK    RENAME(LESTALD0:@STAL2)
     F                                     COMMIT
     F                                     USROPN                                             221427
      ** Settlement Allocation by Timestamp
 
     FLESTALL5  UF   E           K DISK    RENAME(LESTALD0:@STAL5)
     F                                     COMMIT
     F                                     USROPN                                             221427
      ** Settlement Allocation by Transaction File
                                                                                              221427
     FLESTAL5X  UF   E           K DISK    RENAME(LESTALD0:@STALX)                            221427
     F                                     USROPN                                             221427
      ** Settlement Allocation by Transaction File                                            221427
 
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter Lists
     D P_RTCD          S              7
     D P_TYPE          S              4
     D P_ACTN          S              1
     D P_LNRF          S              6
     D P_VDAT          S              5
     D P_LASQ          S              3
     D P_CNUM          S              6
     D P_FACL          S              5
     D P_FESQ          S              2
     D P_TMST          S             26Z
     D P_PCRF          S             15
 
      ** Key list
     D K_TYPE          S              4
     D K_TMST          S             26Z
     D*K_LNRF*******   S              6S 0                                                    CLE148
     D K_LNRF          S              6A                                                      CLE148
     D K_VDAT          S              5P 0
     D K_LASQ          S              3S 0
     D*K_CNUM***       S              6S 0                                                    CSD027
     D K_CNUM          S              6A                                                      CSD027
     D K_FACL          S              5S 0
     D K_FESQ          S              2S 0
 
      ** Work Variables in calling ZASNMG
     D W_RTCD          S              7
     D X_RTCD          S              7
     D P_PGNM          S             10
     D P_DEST          S              5
     D P_MGID          S              7
     D P_MGSF          S             10
     D P_MGKY          S              4
     D P_MGDA          S             50
     D P_MGTP          S              7
                                                                                              CCB020
      ** Work Variable in calling CBC001001                                                   CCB020
     D COBST           S              4                                                       CCB020
 
      ** Timestamp default value
     D WConstantTS     S             26A   INZ('0001-01-01-00.00.00.000000')
     D WrkDfltTMST     S               Z
      *                                                                                       221427
      * Midas System Phase data area                                                          221427
     D***MPHAS**       E DS                  EXTNAME(MPHAS)                            221427 CCB020
     D*****PHASE       E                     EXTFLD(MPHAS)                             221427 CCB020
                                                                                              221427
      ** Override value                                                                       221427
     D Override        S             60A   INZ('OVRDBF FILE(LESTAL5X) +                       221427
     D                                          TOFILE(LESTALL5)')                            221427
 
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
     C                   WHEN      P_ACTN = 'U'
     C                   EXSR      SrUPD
     C                   WHEN      P_ACTN = 'D'
     C                   EXSR      SrDEL
     C                   WHEN      P_ACTN = 'M'
     C                   EXSR      SrMAT
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
      *  SrDEL    -  Delete Records.                                  *
      *                                                               *
      *  Called by: Main Program                                      *
      *                                                               *
      *  Calls    : none                                              *
      *                                                               *
      *****************************************************************
 
     C     SrDEL         BEGSR
 
     C                   IF        P_TMST <> WrkDfltTMST
 
      ** Move input parameter to key fields.
 
     C                   MOVEL     P_TYPE        K_TYPE
     C                   MOVEL     P_TMST        K_TMST
     C                   MOVEL     P_LNRF        K_LNRF
     C                   MOVEL     P_VDAT        K_VDAT
     C                   MOVEL     P_LASQ        K_LASQ
     C                   MOVEL     P_CNUM        K_CNUM
     C                   MOVEL     P_FACL        K_FACL
     C                   MOVEL     P_FESQ        K_FESQ
 
     C     KeyListL0     SETLL     LESTALL0                               94
     C     KeyListL0     READE     LESTALL0                             9094
     C                   IF        *IN94 = *ON
     C                             OR *IN90 = *ON
     C                   EVAL      *IN95 = *ON
     C                   EXSR      SrReturn
     C                   ENDIF
 
     C                   DOW       *IN94 = *OFF
     C                   EVAL      RECI = 'R'
     C                   UPDATE    @STAL0
     C     KeyListL0     READE     LESTALL0                             9094
     C                   ENDDO
 
     C                   ELSE
 
      ** Move input parameter to key fields.
 
     C                   MOVEL     P_TYPE        K_TYPE
     C                   MOVEL     P_LNRF        K_LNRF
     C                   MOVEL     P_VDAT        K_VDAT
     C                   MOVEL     P_LASQ        K_LASQ
     C                   MOVEL     P_CNUM        K_CNUM
     C                   MOVEL     P_FACL        K_FACL
     C                   MOVEL     P_FESQ        K_FESQ
     C*****W#MPHAS       IFNE      'A'                                                 221427 CCB020
     C                   IF        COBST = '*YES'                                             CCB020
     C     KeyListL5     SETLL     LESTAL5X                               94                  221427
     C     KeyListL5     READE     LESTAL5X                             9094                  221427
     C                   ELSE                                                                 221427
     C     KeyListL5     SETLL     LESTALL5                               94
     C     KeyListL5     READE     LESTALL5                             9094
     C                   ENDIF                                                                221427
     C                   IF        *IN94 = *ON
     C                             OR *IN90 = *ON
     C                   EVAL      *IN95 = *ON
     C                   EXSR      SrReturn
     C                   ENDIF
 
     C                   DOW       *IN94 = *OFF
     C                   EVAL      RECI = 'R'
     C*****W#MPHAS       IFNE      'A'                                                 221427 CCB020
     C                   IF        COBST = '*YES'                                             CCB020
     C                   UPDATE    @STALX                                                     221427
     C     KeyListL5     READE     LESTAL5X                             9094                  221427
     C                   ELSE                                                                 221427
     C                   UPDATE    @STAL5
     C     KeyListL5     READE     LESTALL5                             9094
     C                   ENDIF                                                                221427
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUPD    -  Update Records                                   *
      *                                                               *
      *  Called by: Main Program                                      *
      *                                                               *
      *  Calls    : none                                              *
      *                                                               *
      *****************************************************************
 
     C     SrUPD         BEGSR
 
      ** Move input parameter to key fields.
 
     C                   MOVEL     P_TYPE        K_TYPE
     C                   MOVEL     P_TMST        K_TMST
 
     C     KeyListL2     SETLL     LESTALL2                               94
     C     KeyListL2     READE     LESTALL2                             9094
     C                   IF        *IN94 = *ON
     C                             OR *IN90 = *ON
     C                   EVAL      *IN95 = *ON
     C                   EXSR      SrReturn
     C                   ENDIF
 
     C                   DOW       *IN94 = *OFF
 
      ** Loan Reference Number
 
     C                   IF        P_LNRF <> *BLANKS
     C**********                   AND P_LNRF <> '000000'                                     CLE148
     C                   MOVEL     P_LNRF        LNRF
     C                   ENDIF
 
      ** Loan Amendment Value Date
 
     C                   IF        P_VDAT <> *BLANKS
     C                             AND P_VDAT <> '00000'
     C                   MOVEL     P_VDAT        VDAT
     C                   ENDIF
 
      ** Loan Amendment Sequence Number
 
     C                   IF        P_LASQ <> *BLANKS
     C                             AND P_LASQ <> '000'
     C                   MOVEL     P_LASQ        LASQ
     C                   ENDIF
 
      ** Customer for Fee
 
     C                   IF        P_CNUM <> *BLANKS
     C                             AND P_CNUM <> '000000'
     C                   MOVEL     P_CNUM        CNUM
     C                   ENDIF
 
      ** Facility for Fee
 
     C                   IF        P_FACL <> *BLANKS
     C                             AND P_FACL <> '00000'
     C                   MOVEL     P_FACL        FACL
     C                   ENDIF
 
      ** Fee Sequence
 
     C                   IF        P_FESQ <> *BLANKS
     C                             AND P_FESQ <> '00'
     C                   MOVEL     P_FESQ        FESQ
     C                   ENDIF
 
      ** Parent PC Reference
 
     C                   IF        P_PCRF <> *BLANKS
     C                             AND P_PCRF <> '000000000000000'
     C                   MOVEL     P_PCRF        PTRF
     C                   ENDIF
 
      ** Update LESTALL2
 
     C                   UPDATE    @STAL2
     C     KeyListL2     READE     LESTALL2                             9094
 
     C                   ENDDO
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrMAT    -  Mature Records                                   *
      *                                                               *
      *  Called by: Main Program                                      *
      *                                                               *
      *  Calls    : none                                              *
      *                                                               *
      *****************************************************************
 
     C     SrMAT         BEGSR
 
      ** Move input parameter to key fields.
 
     C                   MOVEL     P_TYPE        K_TYPE
     C                   MOVEL     P_LNRF        K_LNRF
     C                   MOVEL     P_VDAT        K_VDAT
     C                   MOVEL     P_LASQ        K_LASQ
     C                   MOVEL     P_CNUM        K_CNUM
     C                   MOVEL     P_FACL        K_FACL
     C                   MOVEL     P_FESQ        K_FESQ
 
     C*****W#MPHAS       IFNE      'A'                                                 221427 CCB020
     C                   IF        COBST = '*YES'                                             CCB020
     C     KeyListL5     SETLL     LESTAL5X                               94                  221427
     C     KeyListL5     READE     LESTAL5X                             9094                  221427
     C                   ELSE                                                                 221427
     C     KeyListL5     SETLL     LESTALL5                               94
     C     KeyListL5     READE     LESTALL5                             9094
     C                   ENDIF                                                                221427
     C                   IF        *IN94 = *ON
     C                             OR *IN90 = *ON
     C                   EVAL      *IN95 = *ON
     C                   EXSR      SrReturn
     C                   ENDIF
 
     C                   DOW       *IN94 = *OFF
     C                   EVAL      RECI = 'M'
     C*****W#MPHAS       IFNE      'A'                                                 221427 CCB020
     C                   IF        COBST = '*YES'                                             CCB020
     C                   UPDATE    @STALX                                                     221427
     C     KeyListL5     READE     LESTAL5X                             9094                  221427
     C                   ELSE                                                                 221427
     C                   UPDATE    @STAL5
     C     KeyListL5     READE     LESTALL5                             9094
     C                   ENDIF                                                                221427
     C                   ENDDO
 
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
 
     C                   WHEN      *IN95 = *ON
     C                   EVAL      P_RTCD = '*NRF   '
 
     C                   WHEN      *IN96 = *ON
     C                   EVAL      P_RTCD = '*ACTION'
 
     C                   ENDSL
 
      ** Caller requests message sent to program queue
 
     C                   IF        (P_RTCD <> *Blanks)
 
     C                   SELECT
     C                   WHEN      *IN90 = *ON
     C                   EVAL      P_MGID = 'ACO1001'
 
     C                   WHEN      *IN95 = *ON
     C                   EVAL      P_MGID = 'ACO1006'
 
     C                   WHEN      *IN96 = *ON
     C                   EVAL      P_MGID = 'ACO1007'
 
     C                   ENDSL
 
     C                   CALL      'ZASNMG'
     C                   PARM      *BLANKS       W_RTCD
     C                   PARM      'AOSTALU0'    P_PGNM
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
     C                   IF        (X_RTCD <> 'B')
     C                   CALL      'DBERRCTL'
     C                   ENDIF
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
     C     X_RTCD        PARM                    P_RTCD
     C                   PARM                    P_TYPE
     C                   PARM                    P_ACTN
     C                   PARM                    P_LNRF
     C                   PARM                    P_VDAT
     C                   PARM                    P_LASQ
     C                   PARM                    P_CNUM
     C                   PARM                    P_FACL
     C                   PARM                    P_FESQ
     C                   PARM                    P_TMST
     C                   PARM                    P_PCRF
 
      ** Initialise error indicators
 
     C                   EVAL      *IN90 = *OFF
     C                   EVAL      *IN94 = *OFF
     C                   EVAL      *IN95 = *OFF
     C                   EVAL      *IN96 = *OFF
     C                   EVAL      P_RTCD = *BLANKS
 
      ** Define keylist
 
     C     KeyListL0     KLIST
     C                   KFLD                    K_TYPE
     C                   KFLD                    K_TMST
     C                   KFLD                    K_LNRF
     C                   KFLD                    K_VDAT
     C                   KFLD                    K_LASQ
     C                   KFLD                    K_CNUM
     C                   KFLD                    K_FACL
     C                   KFLD                    K_FESQ
 
     C     KeyListL2     KLIST
     C                   KFLD                    K_TYPE
     C                   KFLD                    K_TMST
 
     C     KeyListL5     KLIST
     C                   KFLD                    K_TYPE
     C                   KFLD                    K_LNRF
     C                   KFLD                    K_VDAT
     C                   KFLD                    K_LASQ
     C                   KFLD                    K_CNUM
     C                   KFLD                    K_FACL
     C                   KFLD                    K_FESQ
 
      ** Initialise default timestamp
     C     *ISO          MOVE      WConstantTS   WrkDfltTMST
      *                                                                                       221427
      * Find out Midas System Phase                                                           221427
      *                                                                                       221427
     C******DTAARA       DEFINE                  MPHAS                                 221427 CCB020
     C******LOCK         IN        MPHAS                                               221427 CCB020
     C**********         MOVE      PHASE         W#MPHAS           1                   221427 CCB020
     C**********         OUT       MPHAS                                               221427 CCB020
                                                                                              CCB020
      ** Call program CBC001001 to check if system is in COB or IC                            CCB020
      ** If the return value is *YES, system is in COB                                        CCB020
                                                                                              CCB020
     C                   CALL      'CBC001001'                                                CCB020
     C                   PARM                    COBST                                        CCB020
      *                                                                                       221427
      * If not input cycle phase                                                              221427
      *                                                                                       221427
     C*****W#MPHAS       IFNE      'A'                                                 221427 CCB020
     C                   IF        COBST = '*YES'                                             CCB020
      *                                                                                       221427
      ** Override LESTALL5 if in close of business                                            221427
      *                                                                                       221427
     C                   Z-ADD     56            MSGLEN           15 5                        221427
     C                   MOVEL     Override      PCMD             60                          221427
     C                   CALL      'QCMDEXC'                                                  221427
     C                   PARM                    PCMD                                         221427
     C                   PARM                    MSGLEN                                       221427
     C                   OPEN      LESTAL5X                                                   221427
     C                   ELSE                                                                 221427
     C                   OPEN      LESTALL0                                                   221427
     C                   OPEN      LESTALL2                                                   221427
     C                   OPEN      LESTALL5                                                   221427
     C                   ENDIF                                                                221427
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
