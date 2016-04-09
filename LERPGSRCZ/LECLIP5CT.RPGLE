     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Function code file to screen format')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIP5CT - Customer Loans Conversion Extension              *
      *                                                               *
      *  Function:  This module converts a customer loan from         *
      *             the database.                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CER001  *CREATE    Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Midas LE Loans details file
      *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------
      *
      **------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **------------------------------------------------------------------
      *
      **------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **------------------------------------------------------------------
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Customer Loans Master Files Details in File Format
      *
     D CLIPExFilFmt  E DS                  EXTNAME(LECLX1PD)
      *
      ** Customer Loans Extra Data Files in Screen Format
      *
     D CLIPExScnFmt  E DS                  EXTNAME(LECLRXPD)
      *
      ** External DS for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for SAR Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** External DS for currency details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** First DS for Access Programs, short data structure
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for Access Programs, long data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Format amount returned by standard subroutine ZFRPED
      *
     D                 DS
     D  PZOUT22                1     22
     D  ZOUT21                 1     21
     D  ZOUT20                 1     20
     D  ZNEG                  21     21
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Define parameter fields
      *
     D  PRetCodeIn     S             10
      *
     D  @CURR          S              3
     D  P1CCY          S              3A
      *
     D  PZOUT25        S             25
     D  PZECODE        S              1
     D  PZDECS         S              1  0
     D  PZFLD15        S             15  0
     D  PZFIELD        S             16
      *
     D  PZADATE        S              7
     D  PZDAYNO        S              5  0
     D  PZDATE         S              6  0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN PROCESSING
      *****************************************************************
      *
      ** Initialisation
      *
     C                   EXSR      SRINIT
      *
      ** Convert file fields to screen fields
      *
     C                   EXSR      SRConvert
      *
      ** Return to calling program
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINIT - Initialise the output parameter data structures
      *****************************************************************
     C     SRINIT        BEGSR
      *
     C                   CLEAR                   CLIPExScnFmt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SRConvert - Conversion of file fields to screen fields
      *****************************************************************
     C     SRConvert     BEGSR
      *
      ** Subordinate
      *
     C                   MOVEL     VKSUBR        LSUBR
      *
      ** Mobilisable Customer Number
      *
     C                   MOVEL     VKMOBL        LMOBL
      *
      ** Risk Code
      *
     C                   MOVEL     VKRISC        LRISC
      *
      ** Import/export Code
      *
     C                   MOVEL     VKIMEX        LIMEX
      *
      ** Property Sector Code
      *
     C                   MOVEL     VKPPSC        LPPSC
      *
      ** Degree of Risk
      *
     C                   MOVEL     VKDGRI        LDGRI
      *
      ** BCL Circular 96/127
      *
     C                   MOVEL     VKIM93        LIM93
      *
      ** Claims Type
      *
     C                   MOVEL     VKCLAT        LCLAT
      *
      ** Consumer Credit Code
      *
     C                   MOVEL     VK1UAC        LGUAC
      *
      ** Lump Sum Provision Code
      *
     C                   MOVEL     VKLUSU        LLUSU
      *
      ** Correction Amount
      *
     C                   MOVEL     *BLANKS       @CURR
      *
      ** Get the decimal position based on the currency
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      P1CCY         @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '002'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Convert the correction amount to screen format
      *
     C                   MOVE      *BLANKS       PZFLD15
     C                   MOVE      VKCOAM        PZFLD15
     C                   Z-ADD     A6NBDP        PZDECS
     C                   MOVE      'J'           PZECODE
      *
     C                   CALLB     'ZFRPED'
     C                   PARM                    PZFLD15
     C                   PARM                    PZDECS
     C                   PARM                    PZECODE
     C                   PARM      *BLANKS       PZOUT22
     C                   PARM      *BLANKS       PZOUT25
      *
     C                   IF        ZNEG = '-'
     C                   MOVE      ZOUT21        LCOAM
     C                   ELSE
     C                   MOVE      ZOUT20        LCOAM
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      *
      ** Return Code
      *
     C                   PARM                    PRetCodeIn
      *
      ** Customer Loans Master Files Details in File Format
      *
     C                   PARM                    CLIPExFilFmt
     C                   PARM                    SDBANK
      *
      ** OUTPUT
      *
      ** Customer Loans Extra Data Files in Screen Format
      *
     C                   PARM                    CLIPExScnFmt
     C                   PARM                    P1CCY
      *
      ** Initialise program name
      *
     C                   EVAL      DBPGM = 'LECLIP5CT'
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
