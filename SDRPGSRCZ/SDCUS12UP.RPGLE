     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD CUSD Update - Italian Details')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDCUS12UP - Midas SD Customer Details - Italian Details      *
      *              Database Update                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2006            *
      *                                                               *
      *  Last Amend No. LUC139             Date 23Dec20               *
      *  Prev Amend No. BUG18898A          Date 12Feb09               *
      *                 CER009  *CREATE    Date 16Aug06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC139 - UCI Italian returns upgrade to FM2.1                *
      *  BUG18898A - Changes in APDUMP and APHEADPD (Recompile)       *
      *  CER009 - Puma II Upgrade to MidasPlus                        *
      *                                                               *
      *****************************************************************

     FSDCUT2L1  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      ** Midas SD Customer Details - Puma II

      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in
      ** the Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+

      *****************************************************************

     D*NwCuFilFmt    E DS                  EXTNAME(SDVCUIT2PD)                           LUC139
     D NwCuFilFmt    E DS                  EXTNAME(SDCUT2PD)                             LUC139
     D                                     PREFIX(V)                                     LUC139
      ** Externally desc'd DS for valid transactions

     D NWRCD         E DS                  EXTNAME(SDCUT2PD)

     D PReturn         S              6A
     D PType           S              1A
      **

     D PACTN           S              1A
     D PRTCD           S              7A
     D WFIND           S              1A
      ** Entry Parameters

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  MAIN - Main processing                                       *
      *                                                               *
      *****************************************************************

     C     VPCCUST       CHAIN     SDCUT2L1                           5051

     C                   IF        PType = '1'

     C                   IF        *IN51 = *ON
     C                   EVAL      PRTCD = '*RECLCK'
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF

     C**********         IF        (WFIND <> 'Y' OR                                  LUC139
     C**********                   PACTN = 'I') AND                                  LUC139
     C**********                   *IN50 = *OFF                                      LUC139
     C**********         EVAL      PRTCD = '*RECUPD'                                 LUC139
     C**********         RETURN                                                      LUC139
     C**********         ENDIF                                                       LUC139

     C**********         IF        (WFIND = 'Y' AND                                  LUC139
     C**********                    PACTN <> 'I') AND                                LUC139
     C**********                   *IN50 = *ON                                       LUC139
     C**********         EVAL      PRTCD = '*RECUPD'                                 LUC139
     C**********         RETURN                                                      LUC139
     C**********         ENDIF                                                       LUC139

     C                   ENDIF

     C                   IF        PACTN <> 'D'
     C                   MOVEL     NwCuFilFmt    NWRCD

      ** Perform the necessary file update

     C                   IF        *IN50 = *OFF
     C                   UPDATE    SDCUT2D0
     C                   ELSE
     C                   WRITE     SDCUT2D0
     C                   ENDIF

     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

      ** Program Parameters

     C     *ENTRY        PLIST

      ** Action code

     C                   PARM                    PACTN

      ** Return Code

     C                   PARM                    PRTCD

     C                   PARM                    WFIND

      ** Externally described DS for valid Transaction Detail

     C                   PARM                    NwCuFilFmt

      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)

     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    PReturn
     C                   PARM                    PType

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program, and performs      *
      *          a ROLLBACK.                                          *
      *                                                               *
      *****************************************************************

      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.

      /COPY ZACPYSRC,PSSR_ILE

      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2006
