     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Auto start PEA System Check')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GP000300 - Midas GP Auto start PEA MQ System Check           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. CSC054  *CREATE    Date 23Feb12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC054 - Period End Adjustments                              *
      *                                                               *
      *****************************************************************
 
     FGZSDSVALL1IF   E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
 
     D/COPY GPCPYSRCG,STD_D_SPEC
     D/COPY GPCPYSRCG,PSDS
 
      ** T R A N S A C T I O N    D E T A I L S
 
     D PZone           S             10A
     D PPEA            S              1A
     D PRtCd           S              7A
 
     D WRun            S              1A
     D KSval           S             20A
     D KZone           S             10A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    PRtCd
     C                   PARM                    PZone
     C                   PARM                    PPEA
 
     C     KLSVAL        KLIST
     C                   KFLD                    KZone
     C                   KFLD                    KSval
 
     C                   EVAL      KZone  = PZone
     C                   EVAL      KSval  = 'PEAIndicator'
     C
     C     KLSVAL        CHAIN     GZSDSVALL1
 
     C                   IF        %FOUND()
     C                   EVAL      PPEA   = GIVAL
     C                   ELSE
     C                   EVAL      PPEA   = *BLANKS
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
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
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
