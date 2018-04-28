     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Determine if a JRNRCV has a threshold')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCC002470 - Determine whether a journal receiver has a       *
      *              threshold.                                       *
      *                                                               *
      *  Function: This module is used to determine whether a named   *
      *            journal reciever in the library list has a         *
      *            threshold defined.                                 *
      *                                                               *
      *  Component of: SCCMONHJRN                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *  Last Amend No. 196358  *CREATE    Date 31Jul01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  196358 - Monitor journal receiver size in inoput cycle.      *
      *                                                               *
      *****************************************************************
      ********************************************************************
      * Type Definition for the RRCV0100 Format, for the Retrieve Journal
      * Receiver Information (QjoRtvJrnReceiverInformation) API
      * receiver variable.
      ********************************************************************
     DQJOV0100         DS
      *                                             Qjo RRCV0100
     D QJOBRTN02               1      4B 0
      *                                             Bytes Returned
     D QJOBAVL02               5      8B 0
      *                                             Bytes Available
     D QJOJRN00                9     18
      *                                             Jrn Rcv Name
     D QJOJRLN00              19     28
      *                                             Jrn Rcv Lib Name
     D QJOJN01                29     38
      *                                             Jrn Name
     D QJOJLN00               39     48
      *                                             Jrn Lib Name
     D QJOSHOLD               49     52B 0
      *                                             Threshold
     D QJOSIZE                53     56B 0
      *                                             Size
     D QJOASP00               57     60B 0
      *                                             Aux Stg Pool
     D QJONBRJE               61     64B 0
      *                                             Num Jrn Entries
     D QJOMESDL               65     68B 0
      *                                             Max Ent Spc Data Len
     D QJOMNVI                69     72B 0
      *                                             Max Null Val Ind
     D QJOFSNBR               73     76B 0
      *                                             First Seq Num
     D QJORSV101              77     80B 0
      *                                             Reserved 1
     D QJOLSNBR               81     84B 0
      *                                             Last Seq Num
     D QJORSV201              85     88B 0
      *                                             Reserved 2
     D QJOTATUS               89     89
      *                                             Status
     D QJOMFLV                90     90
      *                                             Min Fxd Len Val
     D QJORMOV                91     91
      *                                             Rcv Max Opt Val
     D QJORSV301              92     95
      *                                             Reserved 3
     D QJOADT                 96    108
      *                                             Attach Date Time
     D QJODDT                109    121
      *                                             Detach Date Time
     D QJOSDT                122    134
      *                                             Saved Date Time
     D QJOTEXT00             135    184
      *                                             Text
     D QJOPT                 185    185
      *                                             Pending Trans
     D QJORJT02              186    186
      *                                             Remote Jrn Type
     D QJOLJN00              187    196
      *                                             Lcl Jrn Name
     D QJOLJLN00             197    206
      *                                             Lcl Jrn Lib Name
     D QJOLJS00              207    214
      *                                             Lcl Jrn System
     D QJOLJRLN              215    224
      *                                             Lcl Jrn Rcv Lib Name
     D QJOSJN00              225    234
      *                                             Src Jrn Name
     D QJOSJLN00             235    244
      *                                             Src Jrn Lib Name
     D QJOSJS00              245    252
      *                                             Src Jrn System
     D QJOSJRLN              253    262
      *                                             Src Jrn Rcv Lib Name
     D QJORJRL               263    272
      *                                             Redirected Jrn Rcv Lib
     D QJODJRN               273    282
      *                                             Dual Jrn Rcv Name
     D QJODJRLN00            283    292
      *                                             Dual Jrn Rcv Lib Name
     D QJOPJRN               293    302
      *                                             Prev Jrn Rcv Name
     D QJOPJRLN              303    312
      *                                             Prev Jrn Rcv Lib Name
     D QJOPDJRN              313    322
      *                                             Prev Dual Jrn Rcv Name
     D QJODJRLN01            323    332
      *                                             Prev Dual Jrn Rcv Lib Nm
     D QJONJRN               333    342
      *                                             Next Jrn Rcv Name
     D QJONJRLN              343    352
      *                                             Next Jrn Rcv Lib Name
     D QJONDJRN              353    362
      *                                             Next Dual Jrn Rcv Name
     D QJODJRLN02            363    372
      *                                             Next Dual Jrn Rcv Lib Nm
     D QJONJEL               373    392
      *                                             Num Jrn Entries Long
     D QJOESDLL              393    412
      *                                             Max Ent Spc Data Len Long
     D QJOFSNL               413    432
      *                                             First Seq Num Long
     D QJOLSNL               433    452
      *                                             Last Seq Num Long
     D QJORSV400             453    512
      *                                             Reserved 4
      ********************************************************************
      * Prototype for calling Retrieve Journal Receiver Information
      * (QjoRtvJrnReceiverInformation) API.
      ********************************************************************
     D QJORJRI         C                   'QjoRtvJrnReceiverInformation'
      ********************************************************************
      *****************************************************************
      * Record structure for Error Code Parameter
      * NOTE: The following type definition only defines the fixed
      *   portion of the format.  Verying length field Exception
      *   Data will not be defined here.
      *****************************************************************
     DQUSEC            DS
      *                                             Qus EC
     D QUSBPRV                 1      4B 0
      *                                             Bytes Provided
     D QUSBAVL                 5      8B 0
      *                                             Bytes Available
     D QUSEI                   9     15
      *                                             Exception Id
     D QUSERVED               16     16
      *                                             Reserved
      *
      * Define 'Length' as binary.
      *
     DLength                          4B 0
      *
      * Define decimal version of threshold field.
      *
     DQJOSHOLD10                     12S 0
      *
      *  Define entry parameters.
      *
     C     *ENTRY        plist
      *
      *  Name of journal receiver.
      *
     C                   parm                    JrnRcvr          10
      *
      *  Journal receiver library.
      *
     C                   parm                    RcvrLib          10
      *
      *  Return parameter - Does receiver have a threshold 'Y' or 'N'?
      *
     C                   parm                    Thresh            1
      *
      *  Setup qualified receiver name.
      *
     C                   move      RcvrLib       QualRcvr
     C                   movel     JrnRcvr       QualRcvr
      *
      *  Define length of API return data structure.
      *
     C                   eval      Length = 546
      *
      *  Define name of API data structure.
      *
     C                   eval      RRCV0100 = 'RRCV0100'
      *
      *  Call the API to retrieve the receiver threshold.
      *
     C                   callb     QJORJRI
     C                   parm                    QJOV0100
     C                   parm                    Length
     C                   parm                    QualRcvr         20
     C                   parm                    RRCV0100          8
     C                   parm                    QUSEC
      *
      *  Convert the receiver threshold value from binary to decimal.
      *
     C                   eval      QJOSHOLD10 = QJOSHOLD
      *
      *  If threshold is zero, then there is no threshold.
      *
     C     QJOSHOLD10    ifeq      0
      *
     C                   eval      Thresh = 'N'
      *
     C                   else
      *
      *  If threshold is non-zero, then there is a threshold.
      *
     C                   eval      Thresh = 'Y'
      *
     C                   endif
      *
      *  Terminate program and return to caller.
      *
     C                   eval      *INLR = *ON
     C                   return
