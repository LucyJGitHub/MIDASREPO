     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Corporate actions interdependencies')
/*OVR *  OVRDBF FILE(SECORFLA1) TOFILE(SECORFLA) SHARE(*NO)           *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE7502M - SE Corporate Actions Interdependencies             *
      *                                                               *
      *  Function:  This module determines the interdependencies, if  *
      *             there are any, of all Corporate Actions.  The     *
      *             Actions will be stored in PF/SECORFPM which will  *
      *             then be accessed by SE7502 to be displayed in     *
      *             maintenance.                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSE020  *CREATE    Date 21Mar00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE020 - Corporate Actions Domino Effect Processing          *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      **   SE Corporate Actions Without Any Child Action
     FSECORFLB  IF A E           K DISK    INFSR(*PSSR)
      *
      **   SE Corporate Actions by Parent Action Reference
     FSECORFLA  IF   E           K DISK
     F                                     PREFIX(B)
      *
      **   SE Corporate Actions by Parent Action Reference
     FSECORFLA1 IF   E           K DISK
     F                                     RENAME(@SECOLA:@SECOLA1)
     F                                     PREFIX(A)
      *
      **   SE Corporate Action References
     FSECORFPM  O    E           K DISK
     F                                     USROPN
     F                                     PREFIX(C)
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    Function of indicators                       *
      * ---------------------------------------                       *
      *                                                               *
      *   LR :    Last record                                         *
      *   U7/U8 : Database error                                      *
      *                                                               *
      *   01 : File Indicator on SECORFLB                             *
      *   02 : File Indicator on SECORFL1A                            *
      *   03 : File Indicator on SECORFLA                             *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D/COPY ZACPYSRC,STDDECLARE
 
     D/COPY ZACPYSRC,PSDS
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
     D/COPY ZACPYSRC,FVAL_ARRAY
 
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
      ********************************************************************
      /EJECT
      ********************************************************************
     D DDsSECOLB     E DS                  EXTNAME(SECORFPD)
      ** External DS for Corporate Action by Reference - SECORFLB
      *
     D DDsSECOLA     E DS                  EXTNAME(SECORFPD)
     D                                     PREFIX(B)
      ** External DS for Corporate Action by Reference - SECORFLA
      *
     D DDsSECOPM     E DS                  EXTNAME(SECORFPM)
     D                                     PREFIX(C)
      ** External DS for Corporate Action by Reference - SECORFPM
      *
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      **  Data structure for securities trading details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short data structure for access objects
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long data structure for access objects
      *
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D Idx             S              2S 0
     D W_CORF          S              6A
     D W_LEVL          S              1A
      *
      ** Command length for QCMDEXC
     D CommandLen      S             15P 5 INZ(26)
 
      * Recursive Procedure
     D TreeProc        PR
     D IPName                         6A
     D Idx                            2S 0
      *
      ********************************************************************
      /EJECT
      ********************************************************************
      **    P R O G R A M   S T A R T
      ********************************************************************
      *
      ** Initial Processing
      *
     C                   CLOSE     SECORFPM
      *
     C                   EVAL      Command = 'CLRPFM SECORFPM ' + P#MBR
     C                   CALL      'QCMDEXC'
     C                   PARM                    Command          26
     C                   PARM                    CommandLen
      *
     C                   OPEN      SECORFPM
     C     *HIVAL        SETLL     SECORFLB
     C                   READ      SECORFLB                               01
      *
     C                   DOW       NOT *IN01
     C                   EVAL      W_CORF = MACORF
     C     W_CORF        SETLL     SECORFLA1
     C     W_CORF        READE     @SECOLA1                             0202
      *
     C                   IF        NOT *IN02
     C                   EVAL      W_LEVL = '+'
     C                   ELSE
     C                   EVAL      W_LEVL = ' '
     C                   ENDIF
      *
     C                   MOVEL     DdsSECOLB     DdsSECOPM
     C                   MOVE      W_LEVL        CMALEVL
     C                   WRITE     SECORFM0
      *
     C                   IF        NOT *IN02
     C                   CALLP     TreeProc(W_CORF:Idx)
     C                   ENDIF
      *
     C                   EVAL      Idx = 0
     C                   READ      SECORFLB                               01
     C                   ENDDO
      *
     C                   CLOSE     SECORFPM
     C                   RETURN
      *
      *****************************************************************
      **    P R O G R A M     E N D
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *InzSR - Initial Processing                                   *
      *                                                               *
      * Called by: During Program Activation                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Copyright statement
      *
     C     *ENTRY        PLIST
     C                   PARM                    P#MBR            10
      *
     C                   MOVEA     CPY@          ACT@             80
      *
     C                   EVAL      Idx = 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      *********************************************************************
      * Recursive Procedure
      *********************************************************************
     P TreeProc        B
 
     D TreeProc        PI
     D  IPName                        6A
     D  Idx                           2S 0
 
     D K_PREF          S                   LIKE(MAPREF)
     D K_CREF          S                   LIKE(MAPREF)
      *
     D W_CORF          S              6A
     D W_LEVL          S              1A
      *
     C                   EVAL      Idx = Idx + 1
      *
      ** Read in the current level
      *
     C     IPName        SETLL     SECORFLA
     C     IPName        READE     @SECOLA                                03
      *
      ** Loop through the current level
      *
     C     *IN03         DOWEQ     *OFF
      *
      ** Save file pointer
      *
     C                   MOVE      BMAPREF       K_PREF
     C                   MOVE      BMACORF       K_CREF
     C                   MOVE      BMACORF       W_CORF
     C                   MOVE      Idx           W_LEVL
      *
     C                   MOVEL     DdsSECOLA     DdsSECOPM
     C                   MOVE      W_LEVL        CMALEVL
     C                   WRITE     SECORFM0
 
     C     W_CORF        SETLL     SECORFLA1
     C     W_CORF        READE     @SECOLA1                             0404
     C                   IF        *IN04 = '0'
     C                   CALLP     TreeProc(W_CORF:Idx)
     C                   EVAL      Idx = Idx - 1
     C                   ENDIF
      *
      ** Restore file pointer
      *
     C     K_SECA        KLIST
     C                   KFLD                    K_PREF
     C                   KFLD                    K_CREF
     C     K_SECA        SETGT     SECORFLA
      *
      ** Read next record in current level
      *
     C     K_PREF        READE     @SECOLA                                03
     C                   ENDDO
      *
      ** Return
      *
     C                   RETURN
      *****************************************************************
      /EJECT
 
     P TreeProc        E
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
