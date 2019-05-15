     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2011')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MR MBI/Almonde interface - runday extracts')     *
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR001000 - MBI/Almonde interface - periodic extracts         *
      *                                                               *
      *  (c) Finastra International Limited 2011                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR844222           Date 05Oct11               *
      *                 CMR002  *CREATE    Date 14Feb11               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR844222 - MBI signal file format update (CCR003)            *
      *  CMR002 - MBI/Almonde Interface                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Parameters for ZA0140M
     D P@Rtn           S              1A
     D P@DayN          S              5P 0
     D P@Date          S              6P 0
     D P@Data          S              7A
     D P@Dat8          S              8P 0
     D P@Dat8F         S              8P 0
      *
      ** Parameters for SD2000
     D Error           S              1
     D EndOfMth        S              1
     D EndOfYr         S              1
 
     D WRun            S              1A
     D RtnCode         S              7A
     D RunDay          S              5P 0
     D MthDayNo        S              5P 0
     D YrDayNo         S              5P 0
     D*CurDateOut      S              6A                                                    AR844222
     D CurDateOut      S              8A                                                    AR844222
 
      * External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACD1       E                     EXTFLD(QQACCD)
 
      * First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
 
     C     *Entry        PList
      *
      * Outputs:
      * Returncode
      * Rundays -  current, end of month, end of year
      * Today's date - YYMMDD format
     C                   Parm                    RtnCode
     C                   Parm                    RunDay
     C                   Parm                    MthDayNo
     C                   Parm                    YrDayNo
     C                   Parm                    CurDateOut
 
      ** Initialise period ends
     C                   Z-Add     0             MthDayNo
     C                   Z-Add     0             YrDayNo
 
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CallB     'AOBANKR0'
     C                   Parm      '*DBERR '     @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C     SDBANK        Parm      SDBANK        DSFDY
 
     C                   Eval      RunDay = BJRDNB
 
      ** Convert runday to YYYYMMDD ...
     C                   CallB     'ZA0140M'
     C                   Parm                    P@Rtn
     C                   Parm      BJRDNB        P@DayN
     C                   Parm                    BJDFIN
     C                   Parm      *Zeros        P@Date
     C                   Parm      *Blanks       P@Data
     C                   Parm      *Zeros        P@Dat8
     C                   Parm      *Zeros        P@Dat8F
 
      ** ... and then to YYMMDD
     C                   Move      P@Dat8        CurDateOut
 
      ** Get runday of last working day in month and year
     C                   Call      'SD2000'
     C                   Parm                    EndOfMth
     C                   Parm                    EndOfYr
     C                   Parm                    Error
 
     C                   If        Error = 'Y'
     C                   Exsr      *Pssr
     C                   EndIf
 
     C                   If        EndOfMth  = 'Y'
     C                   Z-Add     RunDay        MthDayNo
     C                   EndIf
     C                   If        EndOfYr   = 'Y'
     C                   Z-Add     RunDay        YrDayNo
     C                   EndIf
 
      ** End program
     C                   Eval      *InLR = *On
     C                   Return
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * *PSSR - Program exception error routine                       *
      *****************************************************************
     C     *PSSR         BegSr
 
     C                   If        WRun = *blanks
 
      * Prevent recursive errors
     C                   Move      'Y'           WRun
 
      * Set return code and dump the program
     C                   Eval      RtnCode = '*Error*'
     C                   Dump
     C                   EndIf
 
      * Set job switches
     C                   Eval      *InLR = *On
 
      * End program
     C                   Return
 
     C                   EndSr
      *****************************************************************
