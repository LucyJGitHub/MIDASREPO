     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ZA Calculate or Retrieve Forward Rate')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  ZACALFWRT - Calculate or retrieve forward rate               *
      *                                                               *
      *  Function:  This will retrieve the forward rate from file     *
      *             FWDRTFE for the date specified (if it exist).     *
      *             If it doesn't exist (date specified is between    *
      *             two dates), the rate will be calculated via       *
      *             interpolation method.                             *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CLE025  *CREATE    Date 20Oct03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CLE025 - Credit Lines                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFWDRT     IF   E           K DISK    INFSR(*PSSR)
     ** Midas DL Forward rates
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D ArrDates        S              5P 0 DIM(27) ASCEND
      ** Array of dates
 
     D ArrRates        S             13P 8 DIM(27)
      ** Array of rates
 
     D                 DS
     D WrkDFW                              LIKE(DFW)
     D   ArrDFW                       5P 0 DIM(25) OVERLAY(WrkDFW)
      ** Number of days forward array
 
     D                 DS
     D WrkRFW                              LIKE(RFW)
     D   ArrRFW                      13P 8 DIM(25) OVERLAY(WrkRFW)
      ** Rates array
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data structure to hold Bank details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Data structure to hold Currency details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry parameters
     D PCurrency       S              3
     D PDate           S              5S 0
     D POutRate        S             13S 8
 
     D PRetCode        S              7
     D POption         S              7
     D WKD1            S              5  0
     D WKD2            S              5  0
     D WKR1            S             13  8
     D WRate           S             13  8
     D WDate           S              5  0
     D WBase           S              5  0
     D WLast           S              2S 0
     D In              S              2S 0
     D Im              S              2S 0
     D Iy              S              2S 0
     D WRun            S              1
 
      ** ZFWDT parameters
     D ZDAYNO          S              5  0
     D ZNRDYS          S              2  0
     D ZDYNBR          S              5  0
     D ZCCY            S              3
     D ZLOC            S              3
 
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
 
     C                   EXSR      SRFillArr
 
     C                   EXSR      SRCalFWRT
 
      ** Convert rate to zone format
 
     C                   EVAL      POutRate = WRate
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFillArr - Fill arrays (date and rate) with values from file *
      *                                                               *
      *****************************************************************
 
     C     SRFillArr     BEGSR
 
     C                   CLEAR                   ArrDates
     C                   CLEAR                   ArrRates
     C                   CLEAR                   ArrRFW
 
     C     PCurrency     CHAIN     FWDRT
 
     C                   EVAL      ArrDates(1) = BJRDNB
 
     C                   IF        %FOUND(FWDRT)  AND  RECI = 'D'
     C                   MOVE      DFW           WrkDFW
     C                   MOVE      RFW           WrkRFW
 
      ** Calculate working days forward
 
     C                   EVAL      ZDAYNO = BJRDNB
     C                   EVAL      ZCCY = PCurrency
     C                   EVAL      ZLOC = *BLANKS
     C                   EVAL      ZNRDYS = A6SPDY
     C                   EXSR      SRZFWDT
     C                   Z-ADD     ZDYNBR        WBase
 
     C                   EVAL      In = 2
     C                   EVAL      Iy = 1
     C                   EVAL      ArrDates (In) = WBase
     C                   EVAL      In = In + 1
 
      ** Fill dates array
 
     C                   DOW       In <= 25  AND  ArrDFW(Iy) <> *ZERO
     C                   EVAL      ArrDates(In) = WBase + ArrDFW(Iy)
     C                   EVAL      In = In + 1
     C                   EVAL      Iy = Iy + 1
     C                   ENDDO
 
     C                   ELSE
     C                   EVAL      In = 2
     C                   ENDIF
 
     C                   EVAL      WLast = In - 1
     C                   EVAL      ArrRates(1) = A6SPRT
     C                   EVAL      ArrRates(2) = A6SPRT
     C                   MOVEA     ArrRFW        ArrRates(3)
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCalFWRT - Calculate/Retrieve Forward Rate                  *
      *                                                               *
      *****************************************************************
 
     C     SRCalFWRT     BEGSR
 
      ** If date is before rundate, set rate to first rate in array
 
     C                   IF        WDate < BJRDNB
     C                   EVAL      WRate = ArrRates(1)
 
     C                   ELSE
     C                   EVAL      In = 1
     C     WDate         LOOKUP    ArrDates(In)                       35
 
      ** If date is after the last date in array,
      ** set rate to last rate in array
 
     C                   IF        *IN35 = *OFF
     C                   EVAL      WRate = ArrRates(WLast)
 
     C                   ELSE
     C                   EVAL      Im = In - 1
     C     WDate         COMP      ArrDates(Im)                           36
 
      ** If date is found in array, set the corresponding rate
 
     C                   IF        *IN36 = *ON
     C                   EVAL      WRate = ArrRates(Im)
 
      ** If date is between two dates, get rate via interpolation method
 
     C                   ELSE
     C                   EVAL      WKR1 = ArrRates(In) - ArrRates(Im)
     C                   EVAL      WKD1 = WDate - ArrDates(Im)
     C                   EVAL      WKD2 = ArrDates(In) - ArrDates(Im)
     C                   EVAL      WRate = WKR1 * WKD1
     C                   EVAL      WRate = WRate / WKD2
     C                   EVAL      WRate = WRate + ArrRates(Im)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZFWDT - Calculate Working Days Forward                     *
      *                                                               *
      *****************************************************************
 
     C     SRZFWDT       BEGSR
 
     C                   CALL      'ZFWDT'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZNRDYS
     C                   PARM                    ZDYNBR
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PCurrency
     C                   PARM                    PDate
     C                   PARM                    POutRate
 
      ** Access Bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POption
     C                   EVAL      DBASE  = 1
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Currency details
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = POption
     C                   EVAL      DBASE  = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise output rate
 
     C                   EVAL      POutRate = *ZERO
 
      ** Convert date to packed decimal
 
     C                   Z-ADD     PDate         WDate
 
     C                   ENDSR
 
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
 
     C                   IF        WRun = *BLANK
     C                   EVAL      Wrun = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
