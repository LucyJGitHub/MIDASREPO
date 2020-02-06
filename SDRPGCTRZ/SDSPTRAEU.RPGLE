     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Spot rate is amendable in respect of EMU')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDSPTRAEU - Spot Rate is amendable in respect of EMU         *
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
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP057   *CREATE   Date 07Nov00               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP057 - Conversion of SPOT Rates into Modular APIs          *
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
 
      ** Base Currency In Indicator
     DBaseCurrIn                      1A
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** EXTERNAL DS FOR GENERAL LEDGER CURRENCY DETAILS
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
      ** EXTERNAL DS FOR CURRENCY DETAILS
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** EXTERNAL DS FOR SWITCHABLE FEATURES FILE
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        ReturnCode
      *
      ** Processing
      *
     C                   EXSR      SRAmend
      *
      * Return
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** PROCESSING
      *****************************************************************
     C     SRAmend       BEGSR
 
      ** Cannot amend the spot rate for a EURO 'IN' currency past its
      ** trans. start date, or for an 'IN' Base currency against EURO or
      ** 'IN' rate
      *
     C                   IF         (PIINCY <> 'Y' AND BaseCurrIn = 'N')
     C                              OR (PIINCY = 'Y' AND BJRDNB < PITPSD
     C                                 AND BaseCurrIn = 'N')
     C                              OR (BaseCurrIn = 'Y' AND PIINCY <> 'Y'
     C                                 AND PICYCD <> BKEURO)
     C                              OR (BaseCurrIn = 'Y' AND PIINCY = 'Y'
     C                                 AND BJRDNB < PITPSD
     C                                 AND PICYCD <> BKEURO)
     C                   EVAL       SprtAmd = 'Y'
     C                   ELSE
     C                   EVAL       SprtAmd = 'N'
     C                   ENDIF
      *
     C     EAmend        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** Return Code
     C                   PARM                    ReturnCode
      *
      ** INPUTS
      *
      ** Currency
     C                   PARM                    PICYCD
      ** IN currency
     C                   PARM                    PIINCY
      ** Transition period
     C                   PARM                    PITPSD
      *
      * OUTPUTS
      *
      ** Spot Rate amendable
     C                   PARM                    SprtAmd           1
      *
     C     *LIKE         DEFINE    A6CYCD        PICYCD
     C     *LIKE         DEFINE    A6INCY        PIINCY
     C     *LIKE         DEFINE    A6TPSD        PITPSD
      *
      *
      ** Check if switchable feature CEU002 is switched on.
      ** Euro rates
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU002'      @SARD             6
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU002'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      *PSSR
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CEU002            1
     C                   ELSE
     C                   MOVE      'N'           CEU002
     C                   ENDIF
      *
      ** Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access general ledger for Euro currency name
      *
     C                   IF        CEU002 = 'Y'
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Access currency file for base rate details
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      BJCYCD        @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *
      ** Set up Base Currency In indicator
      *
     C                   CALLB     'SDSPTR4EU'
     C                   PARM                    ReturnCode
     C                   PARM      A6INCY        P@incy            1
     C                   PARM      A6TPSD        P@tpsd            5 0
     C     BaseCurrIn    PARM                    CurrIsIn          1
     C     ReturnCode    IFNE      *BLANKS
     C                   MOVEL     'SDSPTR4EU'   DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     '*CALL'       DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
