     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Recalculation Xrate OUT ccy vs IN Base')      *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDSPTR3EU - Recalculation Xrate OUT ccy vs IN Base           *
      *  This Module is the ILE version of S/R RECALC in SD0020M      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CGL165             Date 23Feb15               *
      *                 CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP057   *CREATE   Date 12Nov00               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CAP057 - Conversion of SPOT Rates into Modular APIs         *
      *                                                               *
      *****************************************************************
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      *
      * Currency codes
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      * Data Structures used by Access Programs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Bank details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Working variables
     D #1INER          S                   LIKE(A6INER)
     D #1INMD          S                   LIKE(A6MDIN)
      *
      ** Init program
     C                   EXSR      INIPGM
     C                   EXSR      RECALC
      *
     C                   RETURN
      *****************************************************************
      * INIPGM - Init program                                         *
      *****************************************************************
     C     INIPGM        BEGSR
      ** Reset output parameters
     C                   MOVEL     *BLANK        RetCodeIn
     C                   Z-ADD     0             #1INER
     C                   MOVEL     *BLANK        #1INMD
     C                   ENDSR
      *
      *****************************************************************
      * RTVBCY - Retrieve base currency details                       *
      *****************************************************************
     C     RTVBCY        BEGSR
     C     *LIKE         DEFINE    A6EUER        EUSPRT
     C     *LIKE         DEFINE    A6EUMD        EUMDIN
      *
     C                   CALLB     'AOBANKR0'                           90
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFEQ      '*ERROR*'
     C     *IN90         OREQ      '1'
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   CALLB     'AOCURRR0'                           90
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      BJCYCD        @KEYCY            3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *IN90         OREQ      '1'
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     A6EUER        EUSPRT
     C                   MOVEL     A6EUMD        EUMDIN
      *
     C                   ENDSR
      *****************************************************************
      * ZXRATE - Compute exchange rate                                *
      *****************************************************************
     C     ZXRATE        BEGSR
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1           13 8
     C                   PARM                    ZMDI1             1
     C                   PARM                    ZRATE2           13 8
     C                   PARM                    ZMDI2             1
     C                   PARM                    ZRATEX           13 8
     C                   PARM                    ZMDIX             1
     C                   ENDSR
      *****************************************************************
      *  RECALC - Subroutine to do Recalculation for Exchange         *
      *           Rate of 'OUT' Currency Against 'IN' Base            *
      *****************************************************************
      *
     C     RECALC        BEGSR
      *
      ** Calculate Rates if a different Value Has Been Input.
      *
      ** Setup Details To Calculate Exchange Rate.
      *
     C                   Z-ADD     EUSPRT        ZRATE2           13 8
     C                   MOVE      EUMDIN        ZMDI2             1
     C                   Z-ADD     AVSPRT        ZRATE1           13 8
     C                   MOVE      DDMDIN        ZMDI1             1
     C                   EXSR      ZXRATE
      *
      ** If the rate output is less than 1 (this must be the
      ** reciprocal rate), call SR/ZXRATE again with the input
      ** rate reversed to get the correct Spot Rate.
      *
     C                   MOVE      ZMDI1         #1INMD
     C     ZRATEX        IFLT      1
      *
      ** SR/ZXRATE is of no use if the M/D indicator of the two currency
      ** is not the same.  (See SR/ZXRATE)
      *
     C     ZMDI2         ANDEQ     ZMDI1
      *
     C                   Z-ADD     EUSPRT        ZRATE1
     C                   Z-ADD     AVSPRT        ZRATE2
     C                   EXSR      ZXRATE
     C     ZMDI1         IFEQ      'D'
     C                   MOVE      'M'           #1INMD
     C                   ELSE
     C     ZMDI1         IFEQ      'M'
     C                   MOVE      'D'           #1INMD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** Move new Spot Rate into Display Field for Validation.
      *
     C                   Z-ADD     ZRATEX        #1INER
     C                   ENDSR
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      * Parameters
     C     *ENTRY        PLIST
 
      * INPUTS
      *
      * Return code
     C                   PARM                    RetCodeIn
      ** Spot Rate in file format
     C                   PARM                    AVSPRT
      ** Multiply divide indicator
     C                   PARM                    DDMDIN
      * OUPUTS
      ** OUT/IN Exchange Rate
     C                   PARM                    #1INER
      ** OUT/IN Multiply Divide Indicator
     C                   PARM                    #1INMD
      *
     C     *LIKE         DEFINE    A6SPRT        AVSPRT
     C     *LIKE         DEFINE    A6MDIN        DDMDIN
      *
      ** Retrieve base currency details
     C                   EXSR      RTVBCY
      *
     C                   ENDSR
      /COPY ZACPYSRC,PSSR_ILE
