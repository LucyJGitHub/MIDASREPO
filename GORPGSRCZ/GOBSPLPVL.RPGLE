     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GO BSPL Prompt Validation')
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GOBSPLPVL - BSPL Prompt Validation                           *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CAS014             Date 10Aug05               *
      *                 CGP010  *CREATE    Date 17Jan05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAS014 - IAS21 (The Effects of Changes in Foreign Exchange   *
      *           Rates). Recompile.                                  *
      *  CGP010 - Global BSPL                                         *
      *                                                               *
      *****************************************************************
 
 
      ** Message data
     D #MsgData        S             45A
      ** Message ID
     D #MsgID          S              7A
 
 
      ** The maximum size of the error arrays
     D ArrayMax        C                   CONST(75)
      ** Array of Fields in error.
     D FldNameArr      S             10A   DIM(ArrayMax)
      ** Array of error message IDs
     D MsgIDArr        S                   DIM(ArrayMax)
     D                                     LIKE(#MsgID)
      ** Array of error message data.
     D MsgDtaArr       S                   DIM(ArrayMax)
     D                                     LIKE(#MsgData)
 
 
 
      * BSPL Request - Screen Format
     D GOBSRQ        E DS                  EXTNAME(GOBSRQPD)  PREFIX(o_)
     D  o_DDINTDTLS           75     89
     D  o_DDREPDTLS           90    104
 
 
      * BSPL Request - File Format
     D GPBSRQ        E DS                  EXTNAME(GPBSRQPD)
 
 
      * Set output
 
     C                   MOVEL     DDRQTYP       o_DDRQTYP
     C                   MOVEL     DDRQID        o_DDRQID
     C                   MOVEL     DDZNGL        o_DDZNGL
     C                   MOVEL     DDZONE        o_DDZONE
     C                   MOVEL     DDBRC         o_DDBRC
     C                   MOVEL     DDBRGRP       o_DDBRGRP
     C                   MOVEL     DDBRCON       o_DDBRCON
     C                   MOVEL     DDRPSET       o_DDRPSET
     C                   MOVEL     DDHDPTH       o_DDHDPTH
     C                   MOVEL     DDCHART       o_DDCHART
     C                   MOVEL     DDRELPN       o_DDRELPN
     C                   MOVEL     DDCYR         o_DDCYR
     C                   MOVEL     DDCMTH        o_DDCMTH
     C                   MOVEL     DDRPTYP       o_DDRPTYP
     C                   MOVEL     DDRMDUR       o_DDRMDUR
     C                   MOVEL     DDINTDTLS     o_DDINTDTLS
     C                   MOVEL     DDREPDTLS     o_DDREPDTLS
     C                   MOVEL     DDACDBD       o_DDACDBD
     C                   MOVEL     DDPRTZB       o_DDPRTZB
     C                   MOVEL     DDROUND       o_DDROUND
     C                   MOVEL     DDIFCTFR      o_DDIFCTFR
     C                   MOVEL     DDIBCTFR      o_DDIBCTFR
     C                   MOVEL     DDINSID       o_DDINSID
     C                   MOVEL     DDDESC        o_DDDESC
     C                   MOVEL     DDEXPRT       o_DDEXPRT
     C                   MOVEL     DDRFREQ       o_DDRFREQ
     C                   MOVEL     DDRDAYN       o_DDRDAYN
     C                   MOVEL     DDRDATE       o_DDRDATE
 
      * Do validation
 
     C                   CALLB     'GOBSRQVAL'
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * INPUTS
 
      * BSPL Request - Screen Format
     C                   PARM                    GOBSRQ
 
      * OUTPUTS
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
      * BSPL Request - File Format
     C                   PARM                    GPBSRQ
 
     C                   SETON                                        LR
     C                   RETURN
 
      /SPACE 5
      *******************************************************************
      * *INZSR - Initial Processing
      *******************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           50
 
      * INPUTS
 
      * Request Type
     C                   PARM                    DDRQTYP           1
      * Request ID
     C                   PARM                    DDRQID           15
      * Zone or Global
      * Zone To Run Report
     C                   PARM                    DDZNGL            1
     C                   PARM                    DDZONE           10
      * Branch
      * Branch Group
      * Branch Consolidation
     C                   PARM                    DDBRC             3
     C                   PARM                    DDBRGRP          15
     C                   PARM                    DDBRCON           1
      * BSPL Report Set
      * Hierarchy Depth
      * Chart of Accounts
     C                   PARM                    DDRPSET          15
     C                   PARM                    DDHDPTH           2
     C                   PARM                    DDCHART           1
      * Relative Period Number
     C                   PARM                    DDRELPN           3
      * Calendar Year
      * Calendar Month
     C                   PARM                    DDCYR             2
     C                   PARM                    DDCMTH            2
      * Report Type
      * Report Movement Duration
     C                   PARM                    DDRPTYP           1
     C                   PARM                    DDRMDUR           1
      * Interim Currency Type
      * Interim Currency
      * Interim Currency Conv. Methd
      * Interim Currency Nom. Zone
     C                   PARM                    DDINTDTLS        15
      * Report Currency Type
      * Report Currency
      * Report Currency Conv. Methd
      * Report Currency Nom. Zone
     C                   PARM                    DDREPDTLS        15
      * A/c Code Breakdown
      * Print Zero Balances
      * Rounding
     C                   PARM                    DDACDBD           1
     C                   PARM                    DDPRTZB           1
     C                   PARM                    DDROUND           1
      * Include For. Ccy Transfer
      * Include Base Ccy Transfer
     C                   PARM                    DDIFCTFR          1
     C                   PARM                    DDIBCTFR          1
      * Instruction ID
     C                   PARM                    DDINSID          10
      * Description
     C                   PARM                    DDDESC           50
      * Export
     C                   PARM                    DDEXPRT           1
      * Report Frequency
      * Report Day Number
      * (Next) Report Date
     C                   PARM                    DDRFREQ           1
     C                   PARM                    DDRDAYN           2
     C                   PARM                    DDRDATE           6
 
      * OUTPUTS
 
      * BSPL Request - Screen Format
 
     C                   PARM                    GOBSRQ
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
      * BSPL Request - File Format
     C                   PARM                    GPBSRQ
 
     C                   ENDSR
      **********************************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY GOCPYSRC,GOPSSR
      *****************************************************************
