     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan Details Enquiry - LUX Extension')        *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE0192 - Midas LE Loan Details Enquiry - LUX Extension       *
      *                                                               *
      *  Function:  This function displays the Extended Details       *
      *             screen of the Loan Detail Enquiry                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CER001   *CREATE   Date 25Apr05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *                                                               *
      *****************************************************************
      *
      ** Midas ER Customer Loans - LUX Extension File
      *
     FLECLX1PD  IF   E           K DISK
 
      *
      ** Midas ER Loan Details Enquiry Screen - LUX Extension
      *
     FLE0192DF  CF   E             WORKSTN USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error
      ** and warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      **
      **   Named constants
      **   ===============
      **
 
      **
      **   Arrays and Data Structures
      **   ==========================
      **
      *
      ** External DS for Bank Details
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for Currency Details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
     D ScreenFormat  E DS                  EXTNAME(LECLRXPD)
      *
      ** DS for Access Programs
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Data parameters
     D DATALUX         DS          1024
     D**d_LoanNum              1      6  0                                                    CLE148
     D  d_LoanNum              1      6                                                       CLE148
     D  d_LoanChr              1      6
     D  d_Currency             7      9
      *
      ** Format amount returned by standard subroutine ZFRPED
      *
     D                 DS
     D  PZOUT22                1     22
     D  ZOUT21                 1     21
     D  ZOUT20                 1     20
     D  ZNEG                  21     21
 
 
      **
      **   Declared variables
      **   ==================
      **
      *
      ** *ENTRY Parameters
      *
     D p_ReturnCode    S              7
 
     D PZOUT25         S             25
     D PZECODE         S              1
     D PZDECS          S              1  0
     D PZFLD15         S             15  0
     D PZFIELD         S             16
      *
     D PZADATE         S              7
     D PZDAYNO         S              5  0
     D PZDATE          S              6  0
 
     D @Curr           S                   Like(d_Currency)
 
     D i_Exit          S               N
 
     D key_Loan        S                   Like(d_LoanNum)
 
     D c_Exit          C                   Const('Y2U9999')
     D c_Cancel        C                   Const('USR0790')
 
      *
      /EJECT
      *****************************************************************
      *                                                               *
      *                M A I N  P R O C E S S I N G                   *
      *                                                               *
      *****************************************************************
      *
      ** Do initialization everytime
      *
     C                   EXSR      Sr_Init
      *
      ** Do while program termination is not requested
      *
     C                   DOW       Not i_Exit
      *
     C                   EXFMT     LE0192F1
      *
     C                   SELECT
     C                   WHEN      *INKC
     C                   EVAL      p_ReturnCode = c_Exit
     C                   LEAVE
     C                   WHEN      *INKL
     C                   EVAL      p_ReturnCode = c_Cancel
     C                   LEAVE
     C                   OTHER
     C                   ENDSL
      *
     C                   ENDDO
      *
     C                   EVAL      *InLR = *On
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Sr_Init - Initialization Subroutine (done everytime)          *
      *                                                               *
      *****************************************************************
      *
     C     Sr_Init       BEGSR
      *
     C                   EVAL      i_Exit = *On
      *
      ** If Loan entered does not exist in LECLX1PD, do not proceed
      *
     C                   EVAL      key_Loan = d_LoanNum
     C     key_Loan      CHAIN     CLOANKF6
 
     C                   IF        %Found(LECLX1PD)
     C                   EVAL      i_Exit = *Off
     C                   OPEN      LE0192DF
     C                   CLEAR                   ScreenFormat
      *
      ** Retrieve Loan Extended Details (LUX)
     C                   EXSR      Sr_RtvDetail
 
     C                   EVAL      SUSER = PSUser
     C                   EVAL      SJOB  = PSJobName
     C                   EVAL      SPGM  = PSProcName
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Sr_RtvDetail - Subroutine to retrieve Loan details            *
      *                                                               *
      *****************************************************************
      *
     C     Sr_RtvDetail  BEGSR
      *
      ** Loan Number
      *
     C                   EVAL      L6LOAN = d_LoanChr
      *
      ** Subordinate
      *
     C                   MOVEL     VKSUBR        L6SUBR
      *
      ** Mobilisable Customer Number
      *
     C                   MOVEL     VKMOBL        L6MOBL
      *
      ** Risk Code
      *
     C                   MOVEL     VKRISC        L6RISC
      *
      ** Import/export Code
      *
     C                   MOVEL     VKIMEX        L6IMEX
      *
      ** Property Sector Code
      *
     C                   MOVEL     VKPPSC        L6PPSC
      *
      ** Degree of Risk
      *
     C                   MOVEL     VKDGRI        L6DGRI
      *
      ** BCL Circular 96/127
      *
     C                   MOVEL     VKIM93        L6IM93
      *
      ** Claims Type
      *
     C                   MOVEL     VKCLAT        L6CLAT
      *
      ** Consumer Credit Code
      *
     C                   MOVEL     VK1UAC        L6GUAC
      *
      ** Lump Sum Provision Code
      *
     C                   MOVEL     VKLUSU        L6LUSU
      *
      ** Correction Amount
      *
     C                   EVAL      @Curr = *BLANKS
      *
      ** Get the decimal position based on the currency
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      d_Currency    @Curr
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        @RTCD <> *Blanks
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
     C                   MOVE      ZOUT21        L6COAM
     C                   ELSE
     C                   MOVE      ZOUT20        L6COAM
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Standards Input Parameters
      *
     C                   PARM                    p_ReturnCode
     C                   PARM                    DataLux
      *
      ** Initialize program name
      *
     C                   MOVEL     'LE0192   '   DBPGM
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  Program, module and procedure names for database error       *
      *                                                               *
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2005
