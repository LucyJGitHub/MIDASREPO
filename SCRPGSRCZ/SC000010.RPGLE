     H DEBUG
     H COPYRIGHT('(c) Misys Internatinal Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SC Check if Kill Object Lock has run')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000010 - Check if Kill Object Lock component has run.      *
      *             If so then the trigger maintenance program can    *
      *             be called.                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. BG7613  *CREATE    Date 29Jun05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BG7613 - File locks on re-opening IC                         *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** CoB components
     FCBCOMSL0  IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D WRun            S              1
     D KillerJob       S             10    Inz('SCKOBJLCB')
     D Sequence        S              5    Inz('00001')
 
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
 
     C                   Clear                   ReturnCode
 
     C     KeyList       Chain     CBCOMSL0                           60
     C                   If        not %Found
     C                   Eval      ReturnCode = '*Error'
     C                   ExSr      *Pssr
     C                   EndIf
 
     C                   If        DHCSTS = 'C'
     C                   Eval      ReturnCode = '*Complete'
     C                   EndIf
 
     C                   Eval      *InLr = *On
     C                   Return
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BegSr
 
     C     *Entry        PList
     C                   Parm                    ReturnCode
 
     C     KeyList       KList
     C                   KFld                    KillerJob
     C                   KFld                    Sequence
 
     C                   EndSr
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BegSr
 
     C                   If        WRun = *BLANK
     C                   Eval      WRun = 'Y'
     C                   Dump
     C                   EndIf
 
     C                   Eval      *InU7 = *On
     C                   Eval      *InU8 = *On
     C                   EVAL      *InLr = *On
     C                   Return
 
     C                   EndSr
 
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
