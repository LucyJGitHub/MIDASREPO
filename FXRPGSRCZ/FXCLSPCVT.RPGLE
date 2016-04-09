     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CLS Pay-in Schedule Convert')
      *****************************************************************
      *                                                               *
      *  Midas - Foreign Exchange Dealing Module                      *
      *                                                               *
      *  FXCLSPCVT - FX CLS Pay-in Schedule Conversion:               *
      *              File to Screen Format                            *
      *                                                               *
      *  Function:  This module converts the CLS Pay-in Schedule      *
      *             details from file format fields to screen format. *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. 187923             Date 20Dec00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186669             Date 20Nov00               *
      *                 CDL008  *CREATE    Date 02May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  187923 - 2 tier authorisation for CLS pay-in schedules       *
      *           (Recompiled)                                        *
      *  186669 - Last digit/s are erroneously truncated;             *
      *           incorrect value for Number of decimal places        *
      *  CDL008 - Continuous Linked Settlement                        *
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
      ** Standard D-specs
      ** ================
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
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
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
 
      * Pay-In schedule in file format - Header
     D PayISchHFil   E DS                  EXTNAME(FXCLSPSH)
     D                                     PREFIX(HF)
 
      * Pay-In schedule in screen format - Header
     D PayISchHScr   E DS                  EXTNAME(FXCLSPHPD)
     D                                     PREFIX(HS)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** External DS for Bank Details
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** External DS for Dealing Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for Currency Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long Data Structure
     D
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameters for ZDATE2
     D ZDAYNO          S              5P 0
     D ZDATE           S              6P 0
     D ZADATE          S              7A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C**************************************************************
      *
      ** Initialisation
      *
     C                   EXSR      INIT
      *
      ** Set Output Screen Fields
      *
     C                   EXSR      SETFLD
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** INIT - Initialisation
      *****************************************************************
     C     INIT          BEGSR
                                                                                              186669
      ** Get the currency decimal places of CLS ccy                                           186669
                                                                                              186669
     C                   CALL      'AOCURRR0'                                                 186669
     C                   PARM      *BLANKS       @RTCD             7                          186669
     C                   PARM      '*KEY   '     @OPTN             7                          186669
     C                   PARM      HFPYCCY       @AJCD             3                          186669
     C     SDCURR        PARM      SDCURR        DSSDY                                        186669
                                                                                              186669
      ** Database error                                                                       186669
                                                                                              186669
     C     @RTCD         IFNE      *BLANKS                                                    186669
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************  186669
     C                   MOVEL     '902'         DBASE                          * DBERR 902*  186669
     C                   MOVEL     @AJCD         DBKEY                          ************  186669
     C                   EXSR      *PSSR                                                      186669
     C                   ENDIF                                                                186669
      *
      ** Initialise output fields
      *
     C                   MOVEL     HSCLSACT      ##ACTN            1
     C                   MOVEL     *BLANK        PayISchHScr
     C                   MOVEL     ##ACTN        HSCLSACT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** SETFLD - Set Output Screen Fields
      *****************************************************************
     C     SETFLD        BEGSR
      *
      ** CLS Currency
      *
     C                   MOVE      HFPYCCY       HSCLSCCY
      *
      ** CLS Nostro
      *
     C                   MOVE      HFPYNOST      HSCLSNST
      *
      ** CLS Value Date
      *
     C                   MOVE      HFPYVALD      ZDAYNO
     C                   EXSR      CVTDAT
     C                   MOVE      ZDATE         HSCLSVDT
      *
      ** CLS Sequence number
      *
     C                   MOVE      HFPYSEQN      HSCLSSEQ
      *
      ** CLS Time difference
      *
     C                   MOVE      HFPYTIMD      HSCLSTMD
      *
      ** CLS Profit Centre
      *
     C                   MOVE      HFPYPRFC      HSCLSPRF
      *
      ** CLS Total Amount - Pay
      *
     C                   IF        HFPYTOTP <> *ZEROS
     C                   Z-ADD     HFPYTOTP      @@AMTW
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        HSCLSTOP
     C                   ELSE
     C                   MOVE      *BLANKS       HSCLSTOP
     C                   ENDIF
      *
      ** CLS Total Amount - Receive
      *
     C                   IF        HFPYTOTR <> *ZEROS
     C                   Z-ADD     HFPYTOTR      @@AMTW
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        HSCLSTOR
     C                   ELSE
     C                   MOVE      *BLANKS       HSCLSTOR
     C                   ENDIF
      *
      ** CLS CLS Nostro balance Total - Pay
      *
     C                   IF        HFPYNSBP <> *ZEROS
     C                   Z-ADD     HFPYNSBP      @@AMTW
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        HSCLSPYN
     C                   ELSE
     C                   MOVE      *BLANKS       HSCLSPYN
     C                   ENDIF
      *
      ** CLS CLS Nostro balance Total - Receive
      *
     C                   IF        HFPYNSBR <> *ZEROS
     C                   Z-ADD     HFPYNSBR      @@AMTW
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        HSCLSRCN
     C                   ELSE
     C                   MOVE      *BLANKS       HSCLSRCN
     C                   ENDIF
      *
     C                   MOVE      HFPYSNTF      HSCLSSFL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTDAT - Convert Day number to  DDMMYY (OR MMDDYY)            *
      *****************************************************************
     C     CVTDAT        BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDATE
     C                   PARM      *BLanks       ZADATE
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - Format Amount for Display                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZA0921'
     C                   PARM                    @@RETC           10
     C                   PARM                    @@AMTW           15 0
     C                   PARM      A6NBDP        W@DECP            1 0
     C                   PARM      BNDCSP        @@DCSP            1
     C                   PARM      *BLANK        @@AMTP           16
     C                   PARM      *BLANK        @@AMTD           17
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Program Parameters
      *
     C     *ENTRY        PLIST
      *
      ** Inputs:
      ** Return Code
      *
     C                   PARM                    RetCodeIn
      *
      ** Pay-in Schedule in file format - header
      *
     C                   PARM                    PayISchHfil
      *
      ** Output parameters:
      ** Pay-in Schedule in screen format - header
      *
     C                   PARM                    PayISchHScr
      *
      ** Initialize program name
      *
     C                   MOVEL     'FXCLSPCVT'   DBPGM
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
      *
      ** Access Dealing Details
      *
     C**********         CALL      'AODEALR0'                                                 CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDDEALPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      *PSSR                                        *************
     C                   ENDIF
      ***********                                                                             186669
      ***Get*the*currency decimal places of CLS ccy                                           186669
      ***********                                                                             186669
     C***********        CALLB     'AOCURRR0'                                                 186669
     C***********        PARM      *BLANKS       @RTCD             7                          186669
     C***********        PARM      '*KEY   '     @OPTN             7                          186669
     C***********        PARM      HFPYCCY       @AJCD             3                          186669
     C*****SDCURR        PARM      SDCURR        DSSDY                                        186669
      ***********                                                                             186669
      ***Database error                                                                       186669
      ***********                                                                             186669
     C*****@RTCD*        IFNE      *BLANKS                                                    186669
     C***********        MOVEL     'SDCURRPD'    DBFILE                         ************  186669
     C***********        MOVEL     '902'         DBASE                          * DBERR 902*  186669
     C***********        MOVEL     @AJCD         DBKEY                          ************  186669
     C***********        EXSR      *PSSR                                                      186669
     C***********        ENDIF                                                                186669
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
