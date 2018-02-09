     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Default Euro Rates')                          *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDSPTRDEU - Default Euro Rates                               *
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
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP057   *CREATE   Date 30Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
      ** SWIFT currency code + Dealing Ccy Indicator
     D DLSW            DS
     D  #DLSW                         6
     D  #DLCY                         1    OVERLAY(#DLSW:4)
      ** SWIFT currency code + Dealing Ccy Indicator line 2
     D DLSW2           DS
     D  #DLSW2                             LIKE(#DLSW)
     D  #DLCY2                             OVERLAY(#DLSW2:4) LIKE(#DLCY)
 
      ** Retrieve value of reciprocal flag for the currency
     C                   CALLB     'SDSPTR1EU'                          90
     C                   PARM                    RetCodeIn
     C                   PARM                    PICYCD
     C     recip         PARM                    P@OutIn           1
 
     C                   IF        RetCodeIn <> *BLANK  OR *IN90
     C                   MOVEL     'SDSPTR1EU'   DBFILE
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     PICYCD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Calculate euro rates
     C                   CALLB     'SDSPTR2EU'                          90
     C                   PARM                    RetCodeIn
     C                   PARM                    recip
     C                   PARM                    PIMDIN
     C                   PARM                    PISPRT
     C                   PARM                    PIINER
     C                   PARM                    PIINMD
     C                   PARM                    PIDLCI
     C                   PARM                    PISWCY
     C                   PARM                    #SPRA
     C                   PARM                    DLSW
     C                   PARM                    #SMDIN
     C                   PARM                    #SPRA2
     C                   PARM                    DLSW2
     C                   PARM                    #SMDI2
 
     C                   IF        RetCodeIn <> *BLANK  OR *IN90
     C                   MOVEL     'SDSPTR2EU'   DBFILE
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     PICYCD        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   RETURN
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * INPUTS
      *
      * Return code
     C                   PARM                    RetCodeIn
      ** Currency code
     C                   PARM                    PICYCD
      ** Multiply/Divide indicator
     C                   PARM                    PIMDIN
      ** Spot Rate
     C                   PARM                    PISPRT
      ** OUT/EURO Exchange Rate
     C                   PARM                    PIINER
      ** OUT/EURO Multiply/Divide Ind
     C                   PARM                    PIINMD
      ** Dealing currency
     C                   PARM                    PIDLCI
      ** Swift currency code
     C                   PARM                    PISWCY
      * OUPUTS
      *
      ** Spot rate in screen format
     C                   PARM                    #SPRA            14
      ** Dealing currency + SWIFT currency
     C                   PARM                    DLSW
      ** Multiply/divide indicator
     C                   PARM                    #SMDIN
      ** Spot rate against dealing/base currency when #SPRA is
      ** expressed against BKEURO
     C                   PARM                    #SPRA2
      ** Dealing currency + SWIFT currency
     C                   PARM                    DLSW2
      ** Multiply/divide indicator for 2nd line
     C                   PARM                    #SMDI2
 
     C     *LIKE         DEFINE    P@OutIn       recip
     C     *LIKE         DEFINE    A6CYCD        PICYCD
     C     *LIKE         DEFINE    A6MDIN        PIMDIN
     C     *LIKE         DEFINE    A6SPRT        PISPRT
     C     *LIKE         DEFINE    A6INER        PIINER
     C     *LIKE         DEFINE    A6INMD        PIINMD
     C     *LIKE         DEFINE    A6DLCI        PIDLCI
     C     *LIKE         DEFINE    A6SWCY        PISWCY
     C     *LIKE         DEFINE    A6MDIN        #SMDIN
     C     *LIKE         DEFINE    A6MDIN        #SMDI2
     C     *LIKE         DEFINE    #SPRA         #SPRA2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      /COPY ZACPYSRC,PSSR_ILE
