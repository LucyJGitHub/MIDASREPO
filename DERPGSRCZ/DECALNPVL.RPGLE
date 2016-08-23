     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Calculate net present value')
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DECALNPVL - Calculate Net Present Value                      *
      *                                                               *
      *  Function:  This module calculates the net present value      *
      *             based on discount factors.                        *
      *                                                               *
      *  Component of: DECALFWRT, DEWRKEDTA, DEWRKEDTS                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. 218227             Date 27Jun03               *
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CAS001             Date 23Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  218227 - Introduce new program ZAXPINR to perform            *
      *           exponential interpolation of a rate.                *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
      *****************************************************************
 
     FDEDSCFPD  IF   E           K DISK    INFSR(*PSSR)
 
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
 
 
     D*ZDSEXP***       DS                                                                     CAS001
     D**ZISDAT**               1      3P 0                                                    CAS001
     D**ZINDAT**               4      6P 0                                                    CAS001
     D**ZIBDAT**               7      9P 0                                                    CAS001
     D**ZIFDAT**              10     12P 0                                                    CAS001
     D**ZINRAT**              13     19P 9                                                    CAS001
     D**ZIFRAT**              20     26P 9                                                    CAS001
     D**ZIBRAT**              27     33P 9                                                    CAS001
                                                                                              CAS001
      ** Parameters for ZAEXPIN                                                               CAS001
     D  ZISDAT         S              5  0                                                    CAS001
     D  ZINDAT         S              5  0                                                    CAS001
     D  ZIBDAT         S              5  0                                                    CAS001
     D  ZIFDAT         S              5  0                                                    CAS001
     D  ZINRAT         S             13  9                                                    CAS001
     D  ZIFRAT         S             13  9                                                    CAS001
     D  ZIBRAT         S             13  9                                                    CAS001
 
      **************************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7            * RETURN CODE
     C                   PARM                    I#ERMS           30            * ERROR MESSAGE
      * INPUTS
      * currency
     C                   PARM                    I#CCY             3            * CURRENCY
      * spot date
     C                   PARM                    I#SPDT            5 0          * SPOT DATE
      * forward date
     C                   PARM                    I#FWDT            5 0          * FORWARD DATE
      * forward amount
     C                   PARM                    I#FWAM           13 0          * FORWARD AMOUNT
      * OUTPUTS
      * discount factor, spot amount
     C                   PARM                    O#DF             11 9          * DISCNT FACTOR
     C                   PARM                    O#SPAM           13 0          * SPOT AMOUNT
      *
      ***  Initialise output fields.
      *
     C                   Z-ADD     1             O#DF
     C                   Z-ADD     0             O#SPAM
      *
     C                   SETOFF                                       919293
      *
      ***  Key Lists for the Discount factors file
      *
     C     FDDSCK        KLIST
     C                   KFLD                    I#CCY
     C                   KFLD                    I#FWDT
     C     FDDSCP        KLIST
     C                   KFLD                    I#CCY
      *
      ***  First find the Discount Factor to use for discounting.
      *
     C     FDDSCK        SETLL     DEDSCFPD                           91
      *
      ***  If not EOF, Read Equal the next record of the Currency.
      *
     C     *IN91         IFEQ      '0'
     C     FDDSCP        READE     DEDSCFPD                               92
      *
      ***  If a record was read and is the correct date, set up the
      ***  Factor and GOTO Present Value Calculation.
      *
     C     *IN92         IFEQ      '0'
     C     I2MMDN        ANDEQ     I#FWDT
     C                   Z-ADD     I2DF          O#DF
     C                   GOTO      ZNP002
     C                   END
      *
     C                   END
      *
      ***  If a record has not yet been retrieved, reposition the file
      ***  and read the last record of the Currency.
      *
     C     *IN91         IFEQ      '1'
     C     *IN92         OREQ      '1'
     C     FDDSCK        SETGT     DEDSCFPD
      *
      ***  If Record found, set up the Factor and GOTO Present Value
      ***  Calculation, else Currency is not on File
      *
     C     FDDSCP        READPE    DEDSCFPD                               93
     C     *IN93         IFEQ      '0'
     C                   Z-ADD     I2DF          O#DF
     C                   GOTO      ZNP002
     C                   END
      *
     C                   MOVEL     '*NRCD'       I#RTCD
     C                   GOTO      ZNPEND
     C                   END
      *
      ***  If this point has been reached, a record has been found with
      ***  a date greater than the one we want and it will probably be
      ***  necessary to use interpolation, so set up Far Date and Far
      ***  Rate fields (for SR/ZEXPIN).
      *
     C                   Z-ADD     I2MMDN        ZIFDAT
     C                   Z-ADD     I2DF          ZIFRAT
      *
      ***  Read the Previous record to get the Near Discount Factor. If
      ***  not found, then the the record already retrieved is the first
      ***  record of the Currency and that Factor should be used.
      *
     C     FDDSCP        READPE    DEDSCFPD                               91
      *
     C     *IN91         IFEQ      '1'
     C                   Z-ADD     I#SPDT        ZINDAT
     C                   Z-ADD     1             ZINRAT
     C                   ELSE
      *
      ***  Else set up Near Date and Near Factor for interpolation.
      *
     C                   Z-ADD     I2MMDN        ZINDAT
     C                   Z-ADD     I2DF          ZINRAT
     C                   END
      *
      ***  Set up Broken Date and interpolate the Factor
      *
     C                   Z-ADD     I#FWDT        ZIBDAT
      *
      ***Define*parameters*to*PGM/ZEXPIN*as*data-structure.************                       CAS001
      ** Define parameters to PGM/ZAEXPIN                                                     CAS001
      *
     C*****ZPLEXP        PLIST                                                                CAS001
     C**********         PARM                    ZDSEXP                                       CAS001
     C                   Z-ADD     I#SPDT        ZISDAT
     C                   Z-ADD     0             ZIBRAT
      *
     C**********         CALL      'ZEXPIN'      ZPLEXP                                       CAS001
     C**********         CALL      'ZAEXPIN'                                           CAS001 218227
     C                   CALL      'ZAXPINR'                                                  218227
     C                   PARM                    ZISDAT                                       CAS001
     C                   PARM                    ZINDAT                                       CAS001
     C                   PARM                    ZIBDAT                                       CAS001
     C                   PARM                    ZIFDAT                                       CAS001
     C                   PARM                    ZINRAT                                       CAS001
     C                   PARM                    ZIFRAT                                       CAS001
     C                   PARM                    ZIBRAT                                       CAS001
      *
     C                   Z-ADD     ZIBRAT        O#DF
      *
     C     ZNP002        TAG                                                    *** ZNP002 ***
      *
      ***  Present Value is then calculated as:
      ***
      ***
      ***  Present Value =   Future Amount x Discount Factor
      ***
      *
     C     I#FWAM        MULT(H)   O#DF          O#SPAM
      *
      *---------------------------------------------------------------*
      *
     C     ZNPEND        TAG                                                    *** ZNPEND ***
      *
     C                   RETURN
      *
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
