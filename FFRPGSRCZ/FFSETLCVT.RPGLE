     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Settlements convert function')
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFSETLCVT - Futures and Options settlement convert function  *
      *                                                               *
      *  Function:  This module converts futures and options settle-  *
      *             ment fields from their format on file to screen   *
      *             format.                                           *
      *                                                               *
      *  Notes: Check indicators in programs and replace.             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. BG9185             Date 08Nov05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 28Aug98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BG9185 - Correction to CGL029 (Recompile)                    *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to APIs.                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
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
     D CustIns       E DS                  EXTNAME(FFCSETPD)
      ** Customer settlement instructions, screen format
 
     D BrokIns       E DS                  EXTNAME(FFBSETPD)
      ** Broker settlement instructions, screen format
 
     D SetFlFmt      E DS                  EXTNAME(TRSET)
      ** Settlement instructions in file format
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for currency details.
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **Second DS for access programs, long data structure.
 
      ** +--- Named indicators -------------------------------------------+
      ** ¦                                                                ¦
      ** ¦ Map variable names to indicators to allow use of names instead ¦
      ** ¦ of numbers; base the following data structure on a pointer to  ¦
      ** ¦ the indicator array.                                           ¦
     D Indicators      DS                  BASED(pIndicator)
      ** ¦                                                                ¦
     D  NoRecFOCLT            98     98
      ** ¦                                                                ¦
     D  NoRecFound            99     99
      ** ¦                                                                ¦
      ** ¦                                                                ¦
      ** ¦ Set the indicator array pointer                                ¦
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Flag indicating whether details for customer or broker are
      ** required.
     D CustBrokFl      S              1A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Determine instrument currency decimal places
 
     C                   EXSR      DetInCcyDP
 
      ** Proceed according to whether customer or broker instructions
      ** are required
     C                   SELECT
      **                 ------
 
     C                   WHEN      CustBrokFl = 'B'
     C                   EXSR      Broker
 
     C                   WHEN      CustBrokFl = 'C'
     C                   EXSR      Customer
 
     C                   ENDSL
 
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Broker - Processing when broker settlement instructions       *
      *          requested                                            *
      *                                                               *
      *****************************************************************
 
     C     Broker        BEGSR
 
      ** Clear output settlement instructions
 
     C                   CLEAR                   BrokIns
 
     C     BCMC          IFNE      0
     C                   MOVE      BCMC          SBCMC
     C                   END
 
     C     BCMA          IFEQ      0
 
     C     BCPT          IFEQ      'A'
     C                   MOVEL     'A'           SBCMA
     C                   END
 
     C                   ELSE
     C                   MOVEL     *BLANK        ZFIELD           16
     C                   MOVE      BCMA          ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        SBCMA
     C                   END
 
     C     BCMS          IFNE      0
     C                   MOVE      BCMS          SBCMS
     C                   END
 
     C     BCHC          IFNE      0
     C                   MOVE      BCHC          SBCHC
     C                   END
 
     C     BCHA          IFNE      0
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      BCHA          ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        SBCHA
     C                   END
 
     C     BMAR          IFEQ      0
     C                   MOVE      *BLANK        SBMAR
 
     C                   ELSE
 
     C     BMAR          IFEQ      -1
     C                   Z-ADD     0             XBMAR            13 0
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      XBMAR         ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        SBMAR
 
     C                   ELSE
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      BMAR          ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        SBMAR
     C                   END
 
     C                   END
 
     C                   MOVE      BSLT          SBSLT
 
     C     BSLT          IFEQ      04
     C     BSLT          OREQ      06
     C     BSLT          OREQ      15
     C                   MOVE      *BLANK        SBSLA
     C                   MOVE      *BLANK        SBSBR                                         S0111
     C                   ELSE
     C                   MOVE      BSLA          SBSLA
     C                   MOVE      BSBR          SBSBR                                         S0111
     C                   END
 
     C                   MOVE      BFAO          SBFAO
     C                   MOVEL     BCPN          SBCPN
 
     C                   ENDSR
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Customer - Processing when customer settlement instructions   *
      *            requested                                          *
      *                                                               *
      *****************************************************************
 
     C     Customer      BEGSR
 
      ** Clear output settlement instructions
 
     C                   CLEAR                   CustIns
 
     C     CCMC          IFNE      0
     C                   MOVE      CCMC          SCCMC
     C                   END
 
     C     CCMA          IFEQ      0
 
     C     CCPT          IFEQ      'A'
     C                   MOVEL     'A'           SCCMA
     C                   END
 
     C                   ELSE
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      CCMA          ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        SCCMA
     C                   END
 
     C     CCMS          IFNE      0
     C                   MOVE      CCMS          SCCMS
     C                   END
 
     C     CCHC          IFNE      0
     C                   MOVE      CCHC          SCCHC
     C                   END
 
     C     CCHA          IFNE      0
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      CCHA          ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        SCCHA
     C                   END
 
     C     CMAR          IFEQ      0
     C                   MOVE      *BLANK        SCMAR
 
     C                   ELSE
 
     C     CMAR          IFEQ      -1
     C                   Z-ADD     0             XCMAR            13 0
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      XCMAR         ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        SCMAR
 
     C                   ELSE
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      CMAR          ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        SCMAR
     C                   END
 
     C                   END
 
     C                   MOVE      CSLT          SCSLT
 
     C     CSLT          IFEQ      04
     C     CSLT          OREQ      06
     C     CSLT          OREQ      15
     C                   MOVE      *BLANK        SCSLA
     C                   MOVE      *BLANK        SBRSC                                         S0111
     C                   ELSE
     C                   MOVE      CSLA          SCSLA
     C                   MOVE      BRSC          SBRSC                                         S0111
     C                   END
 
     C                   MOVE      CFAO          SCFAO
     C                   MOVEL     CCPN          SCCPN
 
     C                   ENDSR
 
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DetInCcyDP - Determine instrument currency decimal places     *
      *                                                               *
      *****************************************************************
 
     C     DetInCcyDP    BEGSR
 
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*DBERR'      @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      KCCY          @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   Z-ADD     A6NBDP        ZADEC             1 0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Outputs from this procedure
      ** ---------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Customer settlement instructions, screen format
     C                   PARM                    CustIns
      ** Broker settlement instructions, screen format
     C                   PARM                    BrokIns
 
      ** Inputs to this procedure
      ** ------------------------
 
      ** Settlement Instructions in File Format
     C                   PARM                    SetFlFmt
      ** Customer/broker flag (1A)
     C                   PARM                    CustBrokFl
      ** Midas Transaction Number
     C                   PARM                    KTNBR             6
      ** Instrument currency
     C                   PARM                    KCCY              3
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
