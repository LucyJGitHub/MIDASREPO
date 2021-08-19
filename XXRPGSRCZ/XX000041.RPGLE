     H DEBUG
      *****************************************************************
/*S*D****RPGBASE*******************************************************                       LUC109
/*STD *  RPGBASEBND                                                   *                       LUC109
/*EXI *  TEXT('GL Amount Conversion')                                 *                       LUC109
      *****************************************************************
      *                                                               *
      *  Midas - Interface to Head Office Reporting                   *
      *                                                               *
      ***GLM041*-*GL*Amount*Conversion*********************************                       LUC109
      *  XX000041 - GL Amount Conversion                              *                       LUC109
      *                                                               *
  ?   *****************************************************************
  ?   * *** THIS PROGRAM MUST BE COMPILED WITH XXINTFLIB AT THE TOP   *
  ?   * OF LIBL ***                                                   *
  ?   *****************************************************************
      *                                                               *
      *  Function: Utility to convert an amount                       *
      *                                                               *
      ***(C)*COPYRIGHT*MKI*LIMITED*1993,*1994**************************                       LUC109
      *  (c) Finastra International Limited 2016                      *                       LUC109
      *                                                               *
      *  Last Amend No. LUC109             Date 20Sep16               *
      *  Prev Amend No. MMI043             Date 04Dec98               *
      *                 nnnnnn             Date ddMmmyy               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *  MMI043  Balance Sheet Extract                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  C R E A T I O N     P A R A M E T E R S                      *
      *                                                               *
      *****************************************************************
      *
     FSDCURRL0  IF   E           K DISK    INFSR(*PSSR)
      *
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  40 - PF/SDCURRL0   File I/O                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  #INIT  - Initial Processing                                  *
      *  #PROC  - Main Processing                                     *
      *  #TERM  - Program termination                                 *
      *  *PSSR  - Abnormal termination                                *
      *                                                               *
      *****************************************************************
      *
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)              Copyright
     D AMT             S              1    DIM(15)                              Amount
     D INT             S              1    DIM(15)                              Integer
     D DEC             S              1    DIM(3)                               Decimal
     D CAM             S              1    DIM(19)                              Converted amt
      *
      *****************************************************************
      *
     C                   EXSR      #INIT                                        Housekeeping
      *
     C                   EXSR      #PROC                                        Main process
      *
     C                   EXSR      #TERM                                        Termination
      *
      *****************************************************************
      *                                                               *
      *  INIT - Program initialisation.                               *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     #INIT         BEGSR                                                  Initialisation
      *
      ** Entry parameters
      *
     C     *ENTRY        PLIST                                                  Parameters
     C                   PARM                    @@CCYC                         Currency code
     C                   PARM                    @@AMNT           15 0          Amount
     C                   PARM                    @@CAMT           19            Converted amnt
     C                   PARM                    @@EROR            1            Error indicator
      *
     C     *LIKE         DEFINE    A6CYCD        @@CCYC                         Currency code
     C     *LIKE         DEFINE    A6NBDP        @@DECP                         Currency code
      *
      ** Initialisation
      *
     C                   MOVE      'N'           @@PSSR            1            *PSSR Executed
     C                   MOVE      *ZEROS        INT                            Integer
     C                   MOVE      *ZEROS        DEC                            Decimal
     C                   MOVE      *ZEROS        CAM                            Converted
     C                   Z-ADD     *ZEROS        IX                2 0          Index
     C                   Z-ADD     @@AMNT        @@POSA           15 0          Store amount
      *
     C                   MOVEA     CPY@          BIS@             80            Copyright
     C                   MOVE      'N'           @@EROR                         Return code
      *
     C     @@CCYC        CHAIN     SDCURRL0                           40        Currency codes
     C                   Z-ADD     A6NBDP        @@DECP
      *
     C     *IN40         IFEQ      *ON                                          Ended in error
     C                   EXSR      *PSSR                                        **DB ERR 001**
     C                   END
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  #PROC  -  Main process                                       *
      *                                                               *
      *  Called By: Main line                                         *
      *  Calls: S200                                                  *
      *                                                               *
      *****************************************************************
      *
     C     #PROC         BEGSR
      *
      ** Derive sign
      *
     C     @@POSA        IFLT      *ZEROS
     C                   Z-SUB     @@POSA        @@POSA                         Remove sign
     C                   MOVE      '-'           CAM(1)                         Negative
     C                   ELSE
     C                   MOVE      '+'           CAM(1)                         Positive
     C                   ENDIF
      *
     C                   MOVE      @@POSA        @@ALFA           15            Alpha
     C                   MOVEA     @@ALFA        AMT(1)                         Load array
      *
      ** Derive integer & decimal
      *
     C     @@DECP        IFGT      *ZEROS                                       Has decimal pls
      *
     C     16            SUB       @@DECP        IX                             Update index
     C                   MOVEA     AMT(IX)       DEC                            Decimal places
     C     1             ADD       @@DECP        IX                             Update index
     C                   MOVEA     AMT           INT(IX)                        Integer
      *
     C                   ELSE
      *
     C                   MOVE      AMT           INT                            Integer
      *
     C                   ENDIF
      *
     C                   MOVEA     INT           CAM(2)                         Integer
     C                   MOVEA     DEC           CAM(17)                        Decimal places
     C                   MOVEA     CAM           @@CAMT                         Converted amt
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *    #TERM     - Program termination                            *
      *                                                               *
      *    CALLED BY - #PROC, *PSSR                                   *
      *    CALLS     - NONE                                           *
      *                                                               *
      *****************************************************************
      *
     C     #TERM         BEGSR
      *
     C                   RETURN                                                 Return control
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program Error Processing Subroutine.                *
      *                                                               *
      *  Called By: Various                                           *
      *  #AUDIT - Produce #AUDIT Report and End Program               *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR                                                  *** *PSSR  ***
      *
      ** Prevent recursive call
      *
     C     @@PSSR        IFEQ      'N'                                          Recursive call
     C                   MOVE      'Y'           @@PSSR                         *PSSR Executed
     C                   MOVE      'Y'           @@EROR                         Error indicator
     C                   EXSR      #TERM                                        Stop run
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2016
